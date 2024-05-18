import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.Base64;
import java.util.HashMap;

public class VulnerableApp extends HttpServlet {
    // Hard-coded credentials
    private static final String DB_URL = "jdbc:mysql://localhost:3306/enterprise";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "password";
    private static final HashMap<String, String> users = new HashMap<>();

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter out = response.getWriter();
        String action = request.getParameter("action");
        
        if ("login".equals(action)) {
            handleLogin(request, response, out);
        } else if ("profile".equals(action)) {
            showProfile(request, response, out);
        } else {
            showHomePage(out);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        // SQL Injection vulnerability
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String query = "SELECT * FROM users WHERE username = '" + username + "' AND password = '" + password + "'";

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            if (rs.next()) {
                // Insecurely handling session
                String sessionId = Base64.getEncoder().encodeToString((username + ":" + password).getBytes());
                Cookie sessionCookie = new Cookie("sessionId", sessionId);
                response.addCookie(sessionCookie);
                out.println("Login successful!");
            } else {
                out.println("Invalid credentials");
            }
        } catch (SQLException e) {
            out.println("Database error");
        }
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response, PrintWriter out) {
        // Cross-Site Scripting (XSS) vulnerability
        String sessionId = null;
        for (Cookie cookie : request.getCookies()) {
            if ("sessionId".equals(cookie.getName())) {
                sessionId = cookie.getValue();
                break;
            }
        }
        
        if (sessionId != null) {
            String decodedSession = new String(Base64.getDecoder().decode(sessionId));
            String username = decodedSession.split(":")[0];
            out.println("Welcome, " + username + "!");
            out.println("<script>alert('XSS vulnerability!');</script>");
        } else {
            out.println("No session found. Please log in.");
        }
    }

    private void showHomePage(PrintWriter out) {
        out.println("<html><body>");
        out.println("<h1>Welcome to VulnerableApp</h1>");
        out.println("<form action='vulnerableApp' method='GET'>");
        out.println("Username: <input type='text' name='username'><br>");
        out.println("Password: <input type='password' name='password'><br>");
        out.println("<input type='hidden' name='action' value='login'>");
        out.println("<input type='submit' value='Login'>");
        out.println("</form>");
        out.println("</body></html>");
    }
    
    // Insecure deserialization example
    private void insecureDeserialization(HttpServletRequest request, HttpServletResponse response) {
        try {
            ObjectInputStream ois = new ObjectInputStream(request.getInputStream());
            Object obj = ois.readObject();
            // No validation of the deserialized object
        } catch (Exception e) {
            // Improper error handling
            e.printStackTrace();
        }
    }
}

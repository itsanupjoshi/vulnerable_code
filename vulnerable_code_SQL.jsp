<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Search Result</title>
</head>
<body>
    <h1>Search Result</h1>
    <%
        String username = request.getParameter("username");
        // This is a vulnerable line that directly uses user input in SQL query
        String query = "SELECT * FROM users WHERE username = '" + username + "'";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mydb", "user", "password");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(query);

            while (rs.next()) {
                out.println("<p>Username: " + rs.getString("username") + "</p>");
                out.println("<p>Email: " + rs.getString("email") + "</p>");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
</body>
</html>

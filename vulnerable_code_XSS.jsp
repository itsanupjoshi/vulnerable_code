<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Vulnerable Page</title>
</head>
<body>
    <h1>Search User</h1>
    <form action="search.jsp" method="get">
        <label for="username">Enter username:</label>
        <input type="text" id="username" name="username">
        <button type="submit">Search</button>
    </form>
</body>
</html>

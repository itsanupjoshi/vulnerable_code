<?php
// config.php
$dbHost = 'localhost';
$dbUser = 'root';
$dbPass = '';
$dbName = 'vulnerable_app';

// Connect to database
$conn = new mysqli($dbHost, $dbUser, $dbPass, $dbName);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Vulnerable login function
function login($username, $password) {
    global $conn;
    $query = "SELECT * FROM users WHERE username = '$username' AND password = '$password'";
    $result = $conn->query($query);
    if ($result->num_rows > 0) {
        $_SESSION['user'] = $result->fetch_assoc();
        header("Location: dashboard.php");
    } else {
        echo "Invalid login";
    }
}

// Vulnerable file inclusion
if (isset($_GET['page'])) {
    include($_GET['page'] . ".php");
}

// Vulnerable user profile update
if (isset($_POST['update_profile'])) {
    $email = $_POST['email'];
    $id = $_SESSION['user']['id'];
    $query = "UPDATE users SET email = '$email' WHERE id = $id";
    $conn->query($query);
}

// Vulnerable file upload
if (isset($_FILES['upload'])) {
    $uploadDir = 'uploads/';
    $uploadFile = $uploadDir . basename($_FILES['upload']['name']);
    move_uploaded_file($_FILES['upload']['tmp_name'], $uploadFile);
}

// Start session
session_start();

// Vulnerable CSRF protection
if ($_SERVER['REQUEST_METHOD'] === 'POST' && !isset($_POST['csrf_token'])) {
    die("CSRF token missing!");
}

?>

<!-- index.php -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Vulnerable App</title>
</head>
<body>
    <h1>Welcome to the Vulnerable App</h1>
    
    <form method="POST" action="login.php">
        <label for="username">Username:</label>
        <input type="text" name="username" id="username"><br>
        <label for="password">Password:</label>
        <input type="password" name="password" id="password"><br>
        <button type="submit">Login</button>
    </form>

    <form method="POST" action="">
        <input type="hidden" name="csrf_token" value="<?php echo $_SESSION['csrf_token']; ?>">
        <label for="email">Email:</label>
        <input type="text" name="email" id="email"><br>
        <button type="submit" name="update_profile">Update Profile</button>
    </form>

    <form enctype="multipart/form-data" action="" method="POST">
        <label for="upload">Upload file:</label>
        <input type="file" name="upload" id="upload"><br>
        <button type="submit">Upload</button>
    </form>

    <a href="?page=profile">Profile</a>
    <a href="?page=settings">Settings</a>

    <?php
    if (isset($_GET['message'])) {
        echo "<p>" . $_GET['message'] . "</p>";
    }
    ?>
</body>
</html>

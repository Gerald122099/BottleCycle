<?php
require 'config.php';

// Check if a session is already started before calling session_start()
if (session_status() == PHP_SESSION_NONE) {
    session_start();
}

if(isset($_POST["submit"])) {
    $email = $_POST["email"];
    $password = $_POST["password"];

    // Prepare SQL query to prevent SQL injection
    $query = $conn->prepare("SELECT * FROM users WHERE email = ?");
    $query->bind_param("s", $email);
    $query->execute();
    $result = $query->get_result();

    // Check if the email exists in the database
    if($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        
        // Verify the password
        if(password_verify($password, $row['password'])) {
            // Start session and save user data
            $_SESSION["loggedin"] = true;
            $_SESSION["email"] = $email;

            // Redirect to dashboard.html after successful login
            header("Location: dashboard.html");
            exit(); // Ensure the script stops executing after the redirect
        } else {
            echo "<script> alert('Incorrect Password'); </script>";
        }
    } else {
        echo "<script> alert('Email Not Registered'); </script>";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="shortcut icon" type="x-icon" href="logo.png">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bottle Cycle</title>
    <link rel="stylesheet" href="login-register.css">
</head>
<body>
    <header>
        <div class="logo-container">
            <img src="logo.png" alt="Bottle Cycle Logo" class="logo">
            <div class="brand-info">
                <h1>BOTTLE CYCLE</h1>
                <p>Smart Arduino Based Plastic Bottle Bin</p>
            </div>
        </div>
        <nav>
            <ul class="nav-links">
                <li><a href="index.html">Home</a></li>
                <li><a href="aboutus.html">About Us</a></li>
                <li><a href="login.php">Log in</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <section class="login-section">
            <div class="login-box">
                <h2>Login</h2>
                <form method="POST" action="">
                    <div class="input-group">
                        <label for="email">Email</label>
                        <div class="input-field">
                            <i class="fas fa-user"></i>
                            <input type="email" id="email" name="email" placeholder="Enter your email" required>
                        </div>
                    </div>

                    <div class="input-group">
                        <label for="password">Password</label>
                        <div class="input-field">
                            <i class="fas fa-lock"></i>
                            <input type="password" id="password" name="password" placeholder="Enter your password" required>
                        </div>
                    </div>

                    <button type="submit" name="submit" class="login-button">Login</button>
                </form>

                <a href="register.php" class="register-link">Register Account</a>
            </div>
        </section>
    </main>
</body>
</html>

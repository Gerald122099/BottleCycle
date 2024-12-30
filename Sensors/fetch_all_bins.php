<?php

$servername = "localhost";
$username = "root";  // Replace with your database username
$password = "";      // Replace with your database password
$dbname = "bottlecycle-ctu";
// Set the response type to JSON
header('Content-Type: application/json');

// Database connection (replace with your actual DB credentials)
$mysqli = new mysqli($servername, $username, $password, $dbname);

// Check the connection
if ($mysqli->connect_error) {
    die('Connection failed: ' . $mysqli->connect_error);
}

// SQL query to get the total of all bins (no need to group by bin_code for global totals)
$sql = "SELECT 
            SUM(total_small) AS total_small,
            SUM(total_medium) AS total_medium,
            SUM(total_large) AS total_large,
            SUM(total_bottles) AS total_bottles
        FROM bin_summary"; // Sum up all values

$result = $mysqli->query($sql);

// Check if the query was successful
if ($result) {
    // Fetch the total data
    $row = $result->fetch_assoc();
    // Return the summed totals as a JSON response
    echo json_encode($row);
} else {
    echo json_encode(['error' => 'Failed to fetch data']);
}

// Close the database connection
$mysqli->close();
?>

<?php
$servername = "localhost";
$username = "root";  // Replace with your database username
$password = "";      // Replace with your database password
$dbname = "bottlecycle-ctu"; // Replace with your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Fetch the latest 10 bin status records in descending order of id
$sql = "SELECT id, is_full, timestamp FROM bin_status ORDER BY id DESC LIMIT 10";
$result = $conn->query($sql);

$response = [];

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $status_message = "";

        // Format the timestamp to 12-hour format with AM/PM
        $formatted_timestamp = date("Y-m-d h:i A", strtotime($row['timestamp']));

        // Generate message based on is_full value
        switch ($row['is_full']) {
            case 1:
                $status_message = "Bottle Bin Code: AST-{0001} is full. Please empty to avoid overflow.";
                break;
            case 2:
                $status_message = "Medium - more space to occupy.";
                break;
            case 3:
                $status_message = "Bottle bin is low - more spaces to occupy.";
                break;
            default:
                $status_message = "Bottle Bin is Empty.";
                break;
        }

        $response[] = [
            'id' => $row['id'],
            'status' => $status_message,
            'timestamp' => $formatted_timestamp
        ];
    }
} else {
    $response[] = [
        'id' => null,
        'status' => "No data found.",
        'timestamp' => null
    ];
}

echo json_encode($response);

$conn->close();
?>

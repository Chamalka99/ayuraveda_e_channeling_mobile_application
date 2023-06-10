<?php
$servername = "localhost";
$username = "root";
$password = "";
$database = "ayuraveda_app";

// Create a connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Perform a SELECT query
$sql = "SELECT * FROM 'login'";
$result = $conn->query($sql);

// Process the result
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        // Process each row
        echo "ID: " . $row["id"] . " - email: " . $row["email"] . "<br>";
    }
} else {
    echo "No results found";
}

// Close the connection
$conn->close();
?>

<?php
//config.php
$host  = '127.0.0.1';
$db    = 'perpustakaan';
$user  = 'root';
$pass  = '';

try {
    $pdo = new PDO(dsn: "mysql:host=$host;dbname=$db", username: $user, password: $pass);
    $pdo->setAttribute(attribute: PDO::ATTR_ERRMODE, value: PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Could not connect to the database $db :" . $e->getMessage());
}
?>


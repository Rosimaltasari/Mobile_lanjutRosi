<?php
require 'config.php';

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$method = $_SERVER['REQUEST_METHOD'];
$Path_Info = isset($_SERVER['PATH_INFO']) ? $_SERVER['PATH_INFO'] : (isset($_SERVER['ORIG_PATH_INFO']) ? $_SERVER['ORIG_PATH_INFO'] : '');
$request = explode('/', trim($Path_Info, '/'));

$id = isset($request[1]) ? (int)$request[1] : null;

try {
    switch ($method) {
        case 'GET':
            if ($id) {
                $stmt = $pdo->prepare("SELECT pengembalian.*, peminjaman.tanggal_pinjam 
                                       FROM pengembalian 
                                       JOIN peminjaman ON pengembalian.peminjaman_id = peminjaman.id 
                                       WHERE pengembalian.id = ?");
                $stmt->execute([$id]);
                $pengembalian = $stmt->fetch(PDO::FETCH_ASSOC);

                if ($pengembalian) {
                    echo json_encode($pengembalian);
                } else {
                    http_response_code(404);
                    echo json_encode(["message" => "pengembalian not found"]);
                }
            } else {
                $stmt = $pdo->query("SELECT pengembalian.*, peminjaman.tanggal_pinjam 
                                     FROM pengembalian 
                                     JOIN peminjaman ON pengembalian.peminjaman_id = peminjaman.id");
                $pengembalian = $stmt->fetchAll(PDO::FETCH_ASSOC);
                echo json_encode($pengembalian);
            }
            break;

        case 'POST':
            $data = json_decode(file_get_contents("php://input"), true);

            if (!empty($data['tanggal_dikembalikan']) && isset($data['terlambat']) && !empty($data['denda']) && !empty($data['peminjaman_id'])) {
                $stmt = $pdo->prepare("INSERT INTO pengembalian (tanggal_dikembalikan, terlambat, denda, peminjaman_id) VALUES (?, ?, ?, ?)");
                $stmt->execute([$data['tanggal_dikembalikan'], $data['terlambat'], $data['denda'], $data['peminjaman_id']]);
                echo json_encode(["message" => "pengembalian created", "id" => $pdo->lastInsertId()]);
            } else {
                http_response_code(400);
                echo json_encode(["message" => "Invalid data"]);
            }
            break;

        case 'PUT':
            if ($id) {
                $data = json_decode(file_get_contents("php://input"), true);

                $stmt = $pdo->prepare("SELECT * FROM pengembalian WHERE id = ?");
                $stmt->execute([$id]);
                $pengembalian = $stmt->fetch(PDO::FETCH_ASSOC);

                if ($pengembalian) {
                    $tanggal_dikembalikan = $data['tanggal_dikembalikan'] ?? $pengembalian['tanggal_dikembalikan'];
                    $terlambat = $data['terlambat'] ?? $pengembalian['terlambat'];
                    $denda = $data['denda'] ?? $pengembalian['denda'];
                    $peminjaman_id = $data['peminjaman_id'] ?? $pengembalian['peminjaman_id'];

                    $stmt = $pdo->prepare("UPDATE pengembalian SET tanggal_dikembalikan = ?, terlambat = ?, denda = ?, peminjaman_id = ? WHERE id = ?");
                    $stmt->execute([$tanggal_dikembalikan, $terlambat, $denda, $peminjaman_id, $id]);
                    echo json_encode(["message" => "pengembalian updated"]);
                } else {
                    http_response_code(404);
                    echo json_encode(["message" => "pengembalian not found"]);
                }
            } else {
                http_response_code(400);
                echo json_encode(["message" => "ID not provided"]);
            }
            break;

        case 'DELETE':
            if ($id) {
                $stmt = $pdo->prepare("SELECT * FROM pengembalian WHERE id = ?");
                $stmt->execute([$id]);
                $pengembalian = $stmt->fetch(PDO::FETCH_ASSOC);

                if ($pengembalian) {
                    $stmt = $pdo->prepare("DELETE FROM pengembalian WHERE id = ?");
                    $stmt->execute([$id]);
                    echo json_encode(["message" => "pengembalian deleted"]);
                } else {
                    http_response_code(404);
                    echo json_encode(["message" => "pengembalian not found"]);
                }
            } else {
                http_response_code(400);
                echo json_encode(["message" => "ID not provided"]);
            }
            break;

        default:
            http_response_code(405);
            echo json_encode(["message" => "Method not allowed"]);
            break;
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Database error: " . $e->getMessage()]);
}
?>
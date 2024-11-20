<?php
require 'config.php';

// Set header for API access
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

$method = $_SERVER['REQUEST_METHOD'];
$Path_Info = isset($_SERVER['PATH_INFO']) ? $_SERVER['PATH_INFO'] : (isset($_SERVER['ORIG_PATH_INFO']) ? $_SERVER['ORIG_PATH_INFO'] : '');
$request = explode('/', trim($Path_Info, '/'));
$id = isset($request[1]) ? (int)$request[1] : null;

switch ($method) {
    case 'GET':
        if ($id) {
            // Get specific pengembalian by ID with related peminjaman details
            $stmt = $pdo->prepare("
                SELECT pengembalian.*, peminjaman.tanggal_pinjam, peminjaman.tanggal_kembali, anggota.nama, anggota.nim, buku.judul
                FROM pengembalian
                JOIN peminjaman ON pengembalian.peminjaman_id = peminjaman.id
                JOIN anggota ON peminjaman.anggota_id = anggota.id
                JOIN buku ON peminjaman.buku_id = buku.id
                WHERE pengembalian.id = ?
            ");
            $stmt->execute([$id]);
            $pengembalian = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($pengembalian) {
                echo json_encode($pengembalian);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "Pengembalian not found"]);
            }
        } else {
            // Get all pengembalian with related peminjaman details
            $stmt = $pdo->query("
                SELECT pengembalian.*, peminjaman.tanggal_pinjam, peminjaman.tanggal_kembali, anggota.nama, anggota.nim, buku.judul
                FROM pengembalian
                JOIN peminjaman ON pengembalian.peminjaman_id = peminjaman.id
                JOIN anggota ON peminjaman.anggota_id = anggota.id
                JOIN buku ON peminjaman.buku_id = buku.id
            ");
            $pengembalian = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode($pengembalian);
        }
        break;

    case 'POST':
        // Create new pengembalian
        $data = json_decode(file_get_contents("php://input"), true);

        if (!empty($data['tanggal_dikembalikan']) && !empty($data['terlambat']) && !empty($data['denda']) && !empty($data['peminjaman_id'])) {
            $stmt = $pdo->prepare("INSERT INTO pengembalian (tanggal_dikembalikan, terlambat, denda, peminjaman_id) VALUES (?, ?, ?, ?)");
            $stmt->execute([$data['tanggal_dikembalikan'], $data['terlambat'], $data['denda'], $data['peminjaman_id']]);
            echo json_encode(["message" => "Pengembalian created", "id" => $pdo->lastInsertId()]);
        } else {
            http_response_code(400);
            echo json_encode(["message" => "Invalid data"]);
        }
        break;

    case 'PUT':
        // Update pengembalian by ID
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
                echo json_encode(["message" => "Pengembalian updated"]);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "Pengembalian not found"]);
            }
        } else {
            http_response_code(400);
            echo json_encode(["message" => "ID not provided"]);
        }
        break;

    case 'DELETE':
        // Delete pengembalian by ID
        if ($id) {
            $stmt = $pdo->prepare("SELECT * FROM pengembalian WHERE id = ?");
            $stmt->execute([$id]);
            $pengembalian = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($pengembalian) {
                $stmt = $pdo->prepare("DELETE FROM pengembalian WHERE id = ?");
                $stmt->execute([$id]);
                echo json_encode(["message" => "Pengembalian deleted"]);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "Pengembalian not found"]);
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
?>

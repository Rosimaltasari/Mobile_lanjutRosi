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
            // Get specific peminjaman by ID with related anggota and buku details
            $stmt = $pdo->prepare("
                SELECT peminjaman.*, anggota.nama, anggota.nim, buku.judul
                FROM peminjaman
                JOIN anggota ON peminjaman.anggota_id = anggota.id
                JOIN buku ON peminjaman.buku_id = buku.id
                WHERE peminjaman.id = ?
            ");
            $stmt->execute([$id]);
            $peminjaman = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($peminjaman) {
                echo json_encode($peminjaman);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "Peminjaman not found"]);
            }
        } else {
            // Get all peminjaman with related anggota and buku details
            $stmt = $pdo->query("
                SELECT peminjaman.*, anggota.nama, anggota.nim, buku.judul
                FROM peminjaman
                JOIN anggota ON peminjaman.anggota_id = anggota.id
                JOIN buku ON peminjaman.buku_id = buku.id
            ");
            $peminjaman = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode($peminjaman);
        }
        break;

    case 'POST':
        // Create new peminjaman
        $data = json_decode(file_get_contents("php://input"), true);

        if (!empty($data['tanggal_pinjam']) && !empty($data['tanggal_kembali']) && !empty($data['anggota_id']) && !empty($data['buku_id'])) {
            $stmt = $pdo->prepare("INSERT INTO peminjaman (tanggal_pinjam, tanggal_kembali, anggota_id, buku_id) VALUES (?, ?, ?, ?)");
            $stmt->execute([$data['tanggal_pinjam'], $data['tanggal_kembali'], $data['anggota_id'], $data['buku_id']]);
            echo json_encode(["message" => "Peminjaman created", "id" => $pdo->lastInsertId()]);
        } else {
            http_response_code(400);
            echo json_encode(["message" => "Invalid data"]);
        }
        break;

    case 'PUT':
        // Update peminjaman by ID
        if ($id) {
            $data = json_decode(file_get_contents("php://input"), true);

            $stmt = $pdo->prepare("SELECT * FROM peminjaman WHERE id = ?");
            $stmt->execute([$id]);
            $peminjaman = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($peminjaman) {
                $tanggal_pinjam = $data['tanggal_pinjam'] ?? $peminjaman['tanggal_pinjam'];
                $tanggal_kembali = $data['tanggal_kembali'] ?? $peminjaman['tanggal_kembali'];
                $anggota_id = $data['anggota_id'] ?? $peminjaman['anggota_id'];
                $buku_id = $data['buku_id'] ?? $peminjaman['buku_id'];

                $stmt = $pdo->prepare("UPDATE peminjaman SET tanggal_pinjam = ?, tanggal_kembali = ?, anggota_id = ?, buku_id = ? WHERE id = ?");
                $stmt->execute([$tanggal_pinjam, $tanggal_kembali, $anggota_id, $buku_id, $id]);
                echo json_encode(["message" => "Peminjaman updated"]);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "Peminjaman not found"]);
            }
        } else {
            http_response_code(400);
            echo json_encode(["message" => "ID not provided"]);
        }
        break;

    case 'DELETE':
        // Delete peminjaman by ID
        if ($id) {
            $stmt = $pdo->prepare("SELECT * FROM peminjaman WHERE id = ?");
            $stmt->execute([$id]);
            $peminjaman = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($peminjaman) {
                $stmt = $pdo->prepare("DELETE FROM peminjaman WHERE id = ?");
                $stmt->execute([$id]);
                echo json_encode(["message" => "Peminjaman deleted"]);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "Peminjaman not found"]);
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
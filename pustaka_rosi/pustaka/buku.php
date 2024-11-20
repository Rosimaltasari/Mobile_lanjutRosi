<?php
require 'config.php';

// Set header agar API bisa diakses dari luar
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

$method = $_SERVER['REQUEST_METHOD'];
$Path_Info = isset($_SERVER['PATH_INFO']) ? $_SERVER['PATH_INFO'] : (isset($_SERVER['ORIG_PATH_INFO']) ? $_SERVER['ORIG_PATH_INFO'] : '');
$request = explode('/', trim($Path_Info, '/'));
// Ambil ID jika ada
$id = isset($request[1]) ? (int)$request[1] : null;

switch ($method) {
    case 'GET':
        if ($id) {
            // GET Buku by ID
            $stmt = $pdo->prepare("SELECT * FROM buku WHERE id = ?");
            $stmt->execute([$id]);
            $buku = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($buku) {
                echo json_encode($buku);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "Buku not found"]);
            }
        } else {
            // GET All Buku
            $stmt = $pdo->query("SELECT * FROM buku");
            $buku = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode($buku);
        }
        break;
        
    case 'POST':
        // Create new buku
        $data = json_decode(file_get_contents("php://input"), true);
        
        if (!empty($data['judul']) && !empty($data['pengarang']) && !empty($data['penerbit']) && !empty($data['tahun_terbit'])) {
            $stmt = $pdo->prepare("INSERT INTO buku (judul, pengarang, penerbit, tahun_terbit) VALUES (?, ?, ?, ?)");
            $stmt->execute([$data['judul'], $data['pengarang'], $data['penerbit'], $data['tahun_terbit']]);
            echo json_encode(["message" => "Buku created", "id" => $pdo->lastInsertId()]);
        } else {
            http_response_code(400);
            echo json_encode(["message" => "Invalid data"]);
        }
        break;
        
    case 'PUT':
        // Update buku by ID
        if ($id) {
            $data = json_decode(file_get_contents("php://input"), true);
            
            $stmt = $pdo->prepare("SELECT * FROM buku WHERE id = ?");
            $stmt->execute([$id]);
            $buku = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($buku) {
                $judul = $data['judul'] ?? $buku['judul'];
                $pengarang = $data['pengarang'] ?? $buku['pengarang'];
                $penerbit = $data['penerbit'] ?? $buku['penerbit'];
                $tahun_terbit = $data['tahun_terbit'] ?? $buku['tahun_terbit'];
                
                $stmt = $pdo->prepare("UPDATE buku SET judul = ?, pengarang = ?, penerbit = ?, tahun_terbit = ? WHERE id = ?");
                $stmt->execute([$judul, $pengarang, $penerbit, $tahun_terbit, $id]);
                echo json_encode(["message" => "Buku updated"]);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "Buku not found"]);
            }
        } else {
            http_response_code(400);
            echo json_encode(["message" => "ID not provided"]);
        }
        break;
        
    case 'DELETE':
        // Delete buku by ID
        if ($id) {
            $stmt = $pdo->prepare("SELECT * FROM buku WHERE id = ?");
            $stmt->execute([$id]);
            $buku = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($buku) {
                $stmt = $pdo->prepare("DELETE FROM buku WHERE id = ?");
                $stmt->execute([$id]);
                echo json_encode(["message" => "Buku deleted"]);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "Buku not found"]);
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

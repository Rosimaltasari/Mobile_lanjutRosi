<?php
require 'config.php';

//set header agar API bisa di akses dari luar
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST,DELETE");
header("Access-Control-Allow-Headers: Content-Type");

$method = $_SERVER['REQUEST_METHOD'];
$Path_Info = isset($_SERVER['PATH_INFO']) ? $_SERVER['PATH_INFO'] : (isset($_SERVER['ORIG_PATH_INFO']) ? $_SERVER['ORIG_PATH_INFO'] : '');
$request = explode('/', trim($Path_Info, '/'));
//Ambil ID jika ada
$id = isset($request[1]) ? (int)$request[1] : null;

switch ($method) {
    case 'GET' :
        if ($id) {
            //GET buku by ID
            $stmt = $pdo->prepare(query: "SELECT * FROM  buku WHERE id = ?");
            $stmt->execute(params: [$id]);
            $buku = $stmt->fetch(mode: PDO::FETCH_ASSOC);

            if ($buku) {
                echo json_encode(value: $buku);
            }else {
                http_response_code(response_code: 404);
                echo json_encode(value: ["mesage" => "buku not found"]);
            }
        } else {
            //GE All bukus
            $stmt = $pdo->query("SELECT *FROM buku");
            $buku = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode(value: $buku);
        }
        break;

        case 'POST';
        //create new buku
        $data = json_decode(json: file_get_contents(filename: "php://input"), associative: true);

        if (!empty($data['kode_buku']) && !empty($data['judul_buku']) && !empty($data['penerbit']) && !empty($data['pengarang'] && !empty($data['tahun_terbit']))) {
            $stmt = $pdo->prepare("INSERT INTO buku (kode_buku, judul_buku, penerbit, pengarang, tahun_terbit) VALUES (?, ?, ?, ?)");
            $stmt->execute(params: [$data['kode_buku'], $data['judul_buku'], $data['penerbit'],  $data['pengarang'], $data['tahun_terbit']]);
            echo json_encode(value: ["message" => "buku created", "id" => $pdo->lastInsertId()]);
        } else {
            http_response_code(400);
            echo json_encode(value: ["message" => "Invalid data"]);
        }
        break;

        case 'PUT':
            //update studnet by ID
            if ($id) {
                $data = json_decode(json:file_get_contents(filename: "php://input"), assocative: true);

                $stmt = $pdo->prepare(query: "SELECT * FROM buku WHERE id = ?");
                $stmt->execute(params: [$id]);
                $buku = $stmt->fetch(mode: PDO::FETCH_ASSOC);

                if ($buku) {
                    $name = $data['kode_buku'] ?? $buku['kode_buku'];
                    $name = $data['judul_buku'] ?? $buku['judul_buku'];
                    $age = $data['penerbit'] ?? $buku['penerbit'];
                    $major = $data['pengarang'] ?? $buku['pengarang'];
                    $major = $data['tahun_terbit'] ?? $buku['tahun_terbit'];

                    $stmt = $pdo->prepare(query: "UPDATE buku SET name = ?, judul_buku = ? , penerbit = ? , pengarang = ? , tahun_terbit = ? WHERE id = ?");
                    $stmt->execute(params: [$kode_buku, $judul_buku, $penerbit, $pengarang, $tahun_terbit, $id]);
                    echo json_encode(value: ["message" => "buku updated"]);
                } else {
                    http_response_code(404);
                    echo json_encode(value: ["message" => "buku not found"]);
                }
            } else {
                http_response_code(400);
                echo json_encode(value: ["message" => "ID not provided"]);
            }
            break;

            case 'DELETE':
                //dELETE buku BY ID
                if ($id) {
                    $stmt = $pdo->prepare(query: "SELECT *FROM buku WHERE id = ?");
                    $stmt->execute(params: [$id]);
                    $buku  = $stmt->fetch(mode: PDO::FETCH_ASSOC);

                    if ($buku) {
                        $stmt = $pdo->prepare(query: "DELETE FROM buku WHERE id = ?");
                        $stmt->execute(params: [$id]);
                        echo json_encode(value: ["message" => " buku  deleted"]);
                    } else {
                        http_response_code(404);
                        echo json_encode(value: ["message" => "buku not found"]);
                    }
                        
                } else {
                    http_response_code(400);
                        echo json_encode(value: ["message" => "ID not provided"]);
                }
                break;

                default:
                http_response_code(405);
                echo json_encode(value: ["message" => "Method not allowed"]);
                break;
            }
            ?>


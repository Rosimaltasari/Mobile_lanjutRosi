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
            //GET anggota by ID
            $stmt = $pdo->prepare(query: "SELECT * FROM  anggota WHERE id = ?");
            $stmt->execute(params: [$id]);
            $anggota = $stmt->fetch(mode: PDO::FETCH_ASSOC);

            if ($anggota) {
                echo json_encode(value: $anggota);
            }else {
                http_response_code(response_code: 404);
                echo json_encode(value: ["mesage" => "Anggota not found"]);
            }
        } else {
            //GE All anggotas
            $stmt = $pdo->query("SELECT *FROM anggota");
            $anggota = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode(value: $anggota);
        }
        break;

        case 'POST';
        //create new anggota
        $data = json_decode(json: file_get_contents(filename: "php://input"), associative: true);

        if (!empty($data['nama_anggota']) && !empty($data['kode_anggota']) && !empty($data['alamat'] && !empty($data['jenis_kelamin']))) {
            $stmt = $pdo->prepare("INSERT INTO anggota (nama_anggota, kode_anggota, alamat, jenis_kelamin) VALUES (?, ?, ?, ?)");
            $stmt->execute(params: [$data['nama_anggota'], $data['kode_anggota'],  $data['alamat'], $data['jenis_kelamin']]);
            echo json_encode(value: ["message" => "anggota created", "id" => $pdo->lastInsertId()]);
        } else {
            http_response_code(400);
            echo json_encode(value: ["message" => "Invalid data"]);
        }
        break;

        case 'PUT':
            //update studnet by ID
            if ($id) {
                $data = json_decode(json:file_get_contents(filename: "php://input"), assocative: true);

                $stmt = $pdo->prepare(query: "SELECT * FROM anggota WHERE id = ?");
                $stmt->execute(params: [$id]);
                $anggota = $stmt->fetch(mode: PDO::FETCH_ASSOC);

                if ($anggota) {
                    $name = $data['nama_anggota'] ?? $anggota['nama_anggota'];
                    $age = $data['kode_anggota'] ?? $anggota['kode_anggota'];
                    $major = $data['alamat'] ?? $anggota['alamat'];
                    $major = $data['jenis_kelamin'] ?? $anggota['jenis_kelamin'];

                    $stmt = $pdo->prepare(query: "UPDATE anggota SET name = ?, kode_anggota = ?, alamat = ? , jenis_kelamin = ? WHERE id = ?");
                    $stmt->execute(params: [$nama_anggota, $kode_anggota, $alamat, $jenis_kelamin, $id]);
                    echo json_encode(value: ["message" => "anggota updated"]);
                } else {
                    http_response_code(404);
                    echo json_encode(value: ["message" => "anggota not found"]);
                }
            } else {
                http_response_code(400);
                echo json_encode(value: ["message" => "ID not provided"]);
            }
            break;

            case 'DELETE':
                //dELETE anggota BY ID
                if ($id) {
                    $stmt = $pdo->prepare(query: "SELECT *FROM anggota WHERE id = ?");
                    $stmt->execute(params: [$id]);
                    $anggota  = $stmt->fetch(mode: PDO::FETCH_ASSOC);

                    if ($anggota) {
                        $stmt = $pdo->prepare(query: "DELETE FROM anggota WHERE id = ?");
                        $stmt->execute(params: [$id]);
                        echo json_encode(value: ["message" => " anggota  deleted"]);
                    } else {
                        http_response_code(404);
                        echo json_encode(value: ["message" => "anggota not found"]);
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


<?php
require 'config.php';

//set header agar API bisa di akses dari luar
header(header: "Content-Typre: applicatuon/json");
header(header: "Acces-Control-Allow-Origin: *");
header(header: "Acces-Control-Allow-Methods: GET, POST,DELETE");
header(header: "Acces-Control-Allow-Headers: Content-Type");

$method = $_SERVER['REQUEST_METHOD'];
$Path_Info = isset($_SERVER['PATH_INFO']) ? $_SERVER['PATH_INFO'] : (isset($_SERVER['ORIG_PATH_INFO']) ? $_SERVER['ORIG_PATH_INFO'] : '');
$request = explode(separator: '/', string: trim(string: $Path_Info,characters: '/'));
//Ambil ID jika ada
$id = isset($request[1]) ? (int)$request[1] : null;

switch ($method) {
    case 'GET' :
        if ($id) {
            //GET Student by ID
            $stmt = $pdo->prepare(query: "SELECT * FROM anggota WHERE id = ?");
            $stmt->execute(params: [$id]);
            $anggota = $stmt->fetch(mode: PDO::FETCH_ASSOC);

            if ($anggotas) {
                echo json_encode(value: $anggota);
            }else {
                http_response_code(response_code: 404);
                echo json_encode(value: ["mesage" => "Anggota not found"]);
            }
        } else {
            //GE All Students
            $stmt = $pdo->query("SELECT *FROM anggota");
            $anggotas = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode(value: $anggotas);
        }
        break;

        case 'POST';
        //create new anggota
        $data = json_decode(json: file_get_contents(filename: "php://input"), associative: true);

        if (!empty($data['nim_anggota']) && !empty($data['nama_anggota']) && !empty($data['alamat']) && !empty($data['jenis_kelamin'])) {
            $stmt = $pdo->prepare(query: "INSERT INTO anggota (nim_anggota, nama_anggota, alamat, jenis_kelamin) VALUES (?, ?, ?, ?)");
            $stmt->execute(params: [$data['nim_anggota'], $data['nama_anggota'],  $data['alamat'], $data['jenis_kelamin']]);
            echo json_encode(value: ["message" => "Anggota created", "id" => $pdo->lastInsertId()]);
        } else {
            http_response_code(response_code: 400);
            echo json_encode(value: ["message" => "Invalid data"]);
        }
        break;

        case 'PUT':
            //update anggota by ID
            if ($id) {
                $data = json_decode(json:file_get_contents(filename: "php://input"), assocative: true);

                $stmt = $pdo->prepare(query: "SELECT * FROM anggota WHERE id = ?");
                $stmt->execute(params: [$id]);
                $anggota = $stmt->fetch(mode: PDO::FETCH_ASSOC);

                if ($anggota) {
                    $nim_anggota = $data['nim_anggota'] ?? $anggota['nim_anggota'];
                    $nama_anggota = $data['nama_anggota'] ?? $anggota['nama_anggota'];
                    $alamat = $data['alamat'] ?? $anggota['alamat'];
                    $jenis_kelamin = $data['jenis_kelamin'] ?? $anggota['jenis_kelamin'];

                    $stmt = $pdo->prepare(query: "UPDATE anggotas SET nim_anggota = ?, nama_anggota = ?, alamat = ?, jenis_kelamin = ? WHERE id = ?");
                    $stmt->execute(params: [$nim_anggota, $nama_anggota, $alamat, $jenis_kelamin, $id]);
                    echo json_encode(value: ["message" => "Anggota updated"]);
                } else {
                    http_response_code(response_code: 404);
                    echo json_encode(value: ["message" => "Anggota not found"]);
                }
            } else {
                http_response_code(response_code: 400);
                echo json_encode(value: ["message" => "ID not provided"]);
            }
            break;

            case 'DELETE':
                //dELETE ANGGOTA BY ID
                if ($id) {
                    $stmt = $pdo->prepare(query: "SELECT *FROM anggota WHERE id = ?");
                    $stmt->execute(params: [$id]);
                    $anggota  = $stmt->fetch(mode: PDO::FETCH_ASSOC);

                    if ($anggota) {
                        $stmt = $pdo->prepare(query: "DELETE FROM anggotas WHERE id = ?");
                        $stmt->execute(params: [$id]);
                        echo json_encode(value: ["message" => " Anggota  deleted"]);
                    } else {
                        http_response_code(response_code: 404);
                        echo json_encode(value: ["message" => "Anggota not found"]);
                    }
                        
                } else {
                    http_response_code(response_code: 400);
                        echo json_encode(value: ["message" => "ID not provided"]);
                }
                break;

                default:
                http_response_code(response_code: 405);
                echo json_encode(value: ["message" => "Method not allowed"]);
                break;
            }
            ?>


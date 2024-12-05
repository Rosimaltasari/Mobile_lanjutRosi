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
            $stmt = $pdo->prepare(query: "SELECT * FROM peminjaman WHERE id = ?");
            $stmt->execute(params: [$id]);
            $peminjaman = $stmt->fetch(mode: PDO::FETCH_ASSOC);

            if ($peminjamans) {
                echo json_encode(value: $peminjaman);
            }else {
                http_response_code(response_code: 404);
                echo json_encode(value: ["mesage" => "Peminjaman not found"]);
            }
        } else {
            //GE All peminjamn
            $stmt = $pdo->query("SELECT *FROM peminjaman");
            $peminjamans = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode(value: $peminjamans);
        }
        break;

        case 'POST';
        //create new peminjaman
        $data = json_decode(json: file_get_contents(filename: "php://input"), associative: true);

        if (!empty($data['tanggal_pinjam']) && !empty($data['tanggal_kembali']) ) {
            $stmt = $pdo->prepare(query: "INSERT INTO peminjaman (tanggal_pinjam, tanggal_kembali, alamat, jenis_kelamin) VALUES (?, ?, ?, ?)");
            $stmt->execute(params: [$data['tanggal_pinjam'], $data['tanggal_kembali']]);
            echo json_encode(value: ["message" => "Peminjaman created", "id" => $pdo->lastInsertId()]);
        } else {
            http_response_code(response_code: 400);
            echo json_encode(value: ["message" => "Invalid data"]);
        }
        break;

        case 'PUT':
            //update peminjaman by ID
            if ($id) {
                $data = json_decode(json:file_get_contents(filename: "php://input"), assocative: true);

                $stmt = $pdo->prepare(query: "SELECT * FROM peminjaman WHERE id = ?");
                $stmt->execute(params: [$id]);
                $peminjaman = $stmt->fetch(mode: PDO::FETCH_ASSOC);

                if ($peminjaman) {
                    $tanggal_pinjam = $data['tanggal_pinjam'] ?? $peminjaman['tanggal_pinjam'];
                    $tanggal_kembali = $data['tanggal_kembali'] ?? $peminjaman['tanggal_kembali'];

                    $stmt = $pdo->prepare(query: "UPDATE peminjamans SET tanggal_pinjam = ?, tanggal_kembali = ? WHERE id = ?");
                    $stmt->execute(params: [$tanggal_pinjam, $tanggal_kembali, $id]);
                    echo json_encode(value: ["message" => "Peminjaman updated"]);
                } else {
                    http_response_code(response_code: 404);
                    echo json_encode(value: ["message" => "Peminjaman not found"]);
                }
            } else {
                http_response_code(response_code: 400);
                echo json_encode(value: ["message" => "ID not provided"]);
            }
            break;

            case 'DELETE':
                //dELETE PEMINJAMAN BY ID
                if ($id) {
                    $stmt = $pdo->prepare(query: "SELECT *FROM peminjaman WHERE id = ?");
                    $stmt->execute(params: [$id]);
                    $peminjaman  = $stmt->fetch(mode: PDO::FETCH_ASSOC);

                    if ($peminjaman) {
                        $stmt = $pdo->prepare(query: "DELETE FROM peminjamans WHERE id = ?");
                        $stmt->execute(params: [$id]);
                        echo json_encode(value: ["message" => " Peminjaman  deleted"]);
                    } else {
                        http_response_code(response_code: 404);
                        echo json_encode(value: ["message" => "Peminjaman not found"]);
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


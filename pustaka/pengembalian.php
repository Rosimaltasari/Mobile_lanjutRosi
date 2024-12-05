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
            //GET pengembalian by ID
            $stmt = $pdo->prepare(query: "SELECT * FROM pengembalian WHERE id = ?");
            $stmt->execute(params: [$id]);
            $pengembalian = $stmt->fetch(mode: PDO::FETCH_ASSOC);

            if ($pengembalians) {
                echo json_encode(value: $pengembalian);
            }else {
                http_response_code(response_code: 404);
                echo json_encode(value: ["mesage" => "Pengembalian not found"]);
            }
        } else {
            //GE All Pengembalian
            $stmt = $pdo->query("SELECT *FROM pengembalian");
            $pengembalians = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode(value: $pengembalians);
        }
        break;

        case 'POST';
        //create new pengembaian
        $data = json_decode(json: file_get_contents(filename: "php://input"), associative: true);

        if (!empty($data['tanggal_dikembalikan']) && !empty($data['terlambat']) && !empty($data['denda']) ) {
            $stmt = $pdo->prepare(query: "INSERT INTO pengembalian (tanggal_dikembalikan, terlambat, denda) VALUES (?, ?, ?)");
            $stmt->execute(params: [$data['tanggal_dikembalikan'], $data['terlambat'],  $data['denda']]);
            echo json_encode(value: ["message" => "Pengembalian created", "id" => $pdo->lastInsertId()]);
        } else {
            http_response_code(response_code: 400);
            echo json_encode(value: ["message" => "Invalid data"]);
        }
        break;

        case 'PUT':
            //update anggota by ID
            if ($id) {
                $data = json_decode(json:file_get_contents(filename: "php://input"), assocative: true);

                $stmt = $pdo->prepare(query: "SELECT * FROM pengembalian WHERE id = ?");
                $stmt->execute(params: [$id]);
                $pengembalian = $stmt->fetch(mode: PDO::FETCH_ASSOC);

                if ($pengembalian) {
                    $tanggal_dikembalikan = $data['tanggal_dikembalikan'] ?? $anggota['tanggal_dikembalikan'];
                    $terlambat = $data['terlambat'] ?? $anggota['terlambat'];
                    $denda = $data['denda'] ?? $anggota['denda'];

                    $stmt = $pdo->prepare(query: "UPDATE pengembalians SET tanggal_dikembalikan = ?, terlambat = ?, denda = ? WHERE id = ?");
                    $stmt->execute(params: [$tanggal_dikembalikan, $terlambat, $denda, $id]);
                    echo json_encode(value: ["message" => "pengembalian updated"]);
                } else {
                    http_response_code(response_code: 404);
                    echo json_encode(value: ["message" => "Pengebalian not found"]);
                }
            } else {
                http_response_code(response_code: 400);
                echo json_encode(value: ["message" => "ID not provided"]);
            }
            break;

            case 'DELETE':
                //dELETE pengembalian BY ID
                if ($id) {
                    $stmt = $pdo->prepare(query: "SELECT *FROM pengembalian WHERE id = ?");
                    $stmt->execute(params: [$id]);
                    $pengembalian  = $stmt->fetch(mode: PDO::FETCH_ASSOC);

                    if ($pengembalian) {
                        $stmt = $pdo->prepare(query: "DELETE FROM pengembalians WHERE id = ?");
                        $stmt->execute(params: [$id]);
                        echo json_encode(value: ["message" => " Pengembalian  deleted"]);
                    } else {
                        http_response_code(response_code: 404);
                        echo json_encode(value: ["message" => "Pengembalian not found"]);
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


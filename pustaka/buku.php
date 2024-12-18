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
            $stmt = $pdo->prepare(query: "SELECT * FROM buku WHERE id = ?");
            $stmt->execute(params: [$id]);
            $buku = $stmt->fetch(mode: PDO::FETCH_ASSOC);

            if ($bukus) {
                echo json_encode(value: $buku);
            }else {
                http_response_code(response_code: 404);
                echo json_encode(value: ["mesage" => "Buku not found"]);
            }
        } else {
            //GE All Students
            $stmt = $pdo->query("SELECT *FROM buku");
            $bukus = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode(value: $bukus);
        }
        break;

        case 'POST';
        //create new buku
        $data = json_decode(json: file_get_contents(filename: "php://input"), associative: true);

        if (!empty($data['judul_buku']) && !empty($data['pengarang']) && !empty($data['penerbit']) && !empty($data['tahun_terbit'])) {
            $stmt = $pdo->prepare(query: "INSERT INTO buku (judul_buku, pengarang, penerbit, tahun_terbit) VALUES (?, ?, ?, ?)");
            $stmt->execute(params: [$data['judul_buku'], $data['pengarang'],  $data['penerbit'], $data['tahun_terbit']]);
            echo json_encode(value: ["message" => "Buku created", "id" => $pdo->lastInsertId()]);
        } else {
            http_response_code(response_code: 400);
            echo json_encode(value: ["message" => "Invalid data"]);
        }
        break;

        case 'PUT':
            //update buku by ID
            if ($id) {
                $data = json_decode(json:file_get_contents(filename: "php://input"), assocative: true);

                $stmt = $pdo->prepare(query: "SELECT * FROM buku WHERE id = ?");
                $stmt->execute(params: [$id]);
                $buku = $stmt->fetch(mode: PDO::FETCH_ASSOC);

                if ($buku) {
                    $judul_buku = $data['judul_buku'] ?? $buku['judul_buku'];
                    $pengarang = $data['pengarang'] ?? $buku['pengarang'];
                    $penerbit = $data['penerbit'] ?? $buku['penerbit'];
                    $tahun_terbit = $data['tahun_terbit'] ?? $buku['tahun_terbit'];

                    $stmt = $pdo->prepare(query: "UPDATE bukus SET judul_buku = ?, pengarang = ?, penerbit = ?, tahun_terbit = ? WHERE id = ?");
                    $stmt->execute(params: [$judul_buku, $pengarang, $penerbit, $tahun_terbit, $id]);
                    echo json_encode(value: ["message" => "Buku updated"]);
                } else {
                    http_response_code(response_code: 404);
                    echo json_encode(value: ["message" => "Buku not found"]);
                }
            } else {
                http_response_code(response_code: 400);
                echo json_encode(value: ["message" => "ID not provided"]);
            }
            break;

            case 'DELETE':
                //dELETE BUKU BY ID
                if ($id) {
                    $stmt = $pdo->prepare(query: "SELECT *FROM buku WHERE id = ?");
                    $stmt->execute(params: [$id]);
                    $buku  = $stmt->fetch(mode: PDO::FETCH_ASSOC);

                    if ($buku) {
                        $stmt = $pdo->prepare(query: "DELETE FROM bukus WHERE id = ?");
                        $stmt->execute(params: [$id]);
                        echo json_encode(value: ["message" => " Buku  deleted"]);
                    } else {
                        http_response_code(response_code: 404);
                        echo json_encode(value: ["message" => "Buku not found"]);
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


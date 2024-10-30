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
            $stmt = $pdo->prepare(query: "SELECT * FROM student WHERE id = ?");
            $stmt->execute(params: [$id]);
            $student = $stmt->fetch(mode: PDO::FETCH_ASSOC);

            if ($students) {
                echo json_encode(value: $student);
            }else {
                http_response_code(response_code: 404);
                echo json_encode(value: ["mesage" => "Student not found"]);
            }
        } else {
            //GE All Students
            $stmt = $pdo->query("SELECT *FROM student");
            $students = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode(value: $students);
        }
        break;

        case 'POST';
        //create new student
        $data = json_decode(json: file_get_contents(filename: "php://input"), associative: true);

        if (!empty($data['name']) && !empty($data['age']) && !empty($data['major'])) {
            $stmt = $pdo->prepare(query: "INSERT INTO student (name, age, major) VALUES (?, ?, ?)");
            $stmt->execute(params: [$data['name'], $data['age'],  $data['major']]);
            echo json_encode(value: ["message" => "Student created", "id" => $pdo->lastInsertId()]);
        } else {
            http_response_code(response_code: 400);
            echo json_encode(value: ["message" => "Invalid data"]);
        }
        break;

        case 'PUT':
            //update studnet by ID
            if ($id) {
                $data = json_decode(json:file_get_contents(filename: "php://input"), assocative: true);

                $stmt = $pdo->prepare(query: "SELECT * FROM student WHERE id = ?");
                $stmt->execute(params: [$id]);
                $student = $stmt->fetch(mode: PDO::FETCH_ASSOC);

                if ($student) {
                    $name = $data['name'] ?? $student['name'];
                    $age = $data['age'] ?? $student['age'];
                    $major = $data['major'] ?? $student['major'];

                    $stmt = $pdo->prepare(query: "UPDATE students SET name = ?, age = ?, major = ? WHERE id = ?");
                    $stmt->execute(params: [$name, $age, $major, $id]);
                    echo json_encode(value: ["message" => "Student updated"]);
                } else {
                    http_response_code(response_code: 404);
                    echo json_encode(value: ["message" => "Student not found"]);
                }
            } else {
                http_response_code(response_code: 400);
                echo json_encode(value: ["message" => "ID not provided"]);
            }
            break;

            case 'DELETE':
                //dELETE STUDENT BY ID
                if ($id) {
                    $stmt = $pdo->prepare(query: "SELECT *FROM student WHERE id = ?");
                    $stmt->execute(params: [$id]);
                    $student  = $stmt->fetch(mode: PDO::FETCH_ASSOC);

                    if ($student) {
                        $stmt = $pdo->prepare(query: "DELETE FROM students WHERE id = ?");
                        $stmt->execute(params: [$id]);
                        echo json_encode(value: ["message" => " Student  deleted"]);
                    } else {
                        http_response_code(response_code: 404);
                        echo json_encode(value: ["message" => "Student not found"]);
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


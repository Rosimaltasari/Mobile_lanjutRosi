import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pustaka_oci/pages/add_anggota.dart';
import 'package:http/http.dart' as http;
import '../models/anggota.dart';

class Anggotas with ChangeNotifier {
  final List<Anggota> _allAnggota = [];

  List<Anggota> get allAnggota => _allAnggota;

  int get jumlahAnggota => _allAnggota.length;

  Anggota selectById(String id) {
    return _allAnggota.firstWhere((element) => element.id == id);
  }

  Future<void> addAnggota(String nim_anggota, String nama_anggota,
      String alamat, String jenis_kelamin) async {
    Uri url = Uri.parse("http://localhost/pustaka/anggota.php/anggotas");

    try {
      final response = await http.post(
        url,
        body: json.encode({
          "nim_anggota": nim_anggota,
          "nama_anggota": nama_anggota,
          "alamat": alamat,
          "jenis_kelamin": jenis_kelamin,
        }),
      );

      print("THEN FUNCTION");
      print(json.decode(response.body));

      final anggota = Anggota(
        id: json.decode(response.body)["id"],
        nim_anggota: nim_anggota,
        nama_anggota: nama_anggota,
        alamat: alamat,
        jenis_kelamin: jenis_kelamin,
      );

      _allAnggota.add(anggota);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  void editAnggota(
    String id,
    String nim_anggota,
    String nama_anggota,
    String alamat,
    String jenis_kelamin,
    BuildContext context,
  ) {
    Anggota selectPlayer =
        _allAnggota.firstWhere((element) => element.id == id);
    selectPlayer.nim_anggota = nim_anggota;
    selectPlayer.nama_anggota = nama_anggota;
    selectPlayer.alamat = alamat;
    selectPlayer.jenis_kelamin = jenis_kelamin;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Berhasil diubah"),
        duration: Duration(seconds: 2),
      ),
    );
    notifyListeners();
  }

  void deletePlayer(String id, BuildContext context) {
    _allAnggota.removeWhere((element) => element.id == id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Berhasil dihapus"),
        duration: Duration(milliseconds: 500),
      ),
    );
    notifyListeners();
  }

  Future<void> initializeData() async {
    Uri url = Uri.parse("http://localhost/pustaka/anggota.php");
    try {
      var hasilGetData = await http.get(url);
      var dataResponse = json.decode(hasilGetData.body) as Map<String, dynamic>;

      // Create Anggota objects from the response data
      final List<Anggota> loadedAnggotas = [];
      dataResponse.forEach((key, value) {
        loadedAnggotas.add(
          Anggota(
            id: value['id'],
            nim_anggota: value['nim_anggota'],
            nama_anggota: value['nama_anggota'],
            alamat: value['alamat'],
            jenis_kelamin: value['jenis_kelamin'],
          ),
        );
      });

      _allAnggota.clear();
      _allAnggota.addAll(loadedAnggotas);

      print("BERHASIL MEMUAT DATA LIST");
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}

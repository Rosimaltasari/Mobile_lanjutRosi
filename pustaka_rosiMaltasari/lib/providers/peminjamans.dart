import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pustaka_oci/pages/add_peminjaman.dart';
import 'package:http/http.dart' as http;
import '../models/peminjaman.dart';

class Peminjamans with ChangeNotifier {
  final List<Peminjaman> _allPeminjaman = [];

  List<Peminjaman> get allPeminjaman => _allPeminjaman;

  int get jumlahPeminjaman => _allPeminjaman.length;

  Peminjaman selectById(String id) {
    return _allPeminjaman.firstWhere((element) => element.id == id);
  }

  Future<void> AddPeminjaman(
      String tanggal_pinjam, String tanggal_kembali) async {
    Uri url = Uri.parse("http://localhost/pustaka/peminjaman.php/peminjamans");

    try {
      final response = await http.post(
        url,
        body: json.encode({
          "tanggal_pinjam": tanggal_pinjam,
          "tanggal_kembali": tanggal_kembali,
        }),
      );

      print("THEN FUNCTION");
      print(json.decode(response.body));

      final peminjaman = Peminjaman(
        id: json.decode(response.body)["id"],
        tanggal_pinjam: tanggal_pinjam,
        tanggal_kembali: tanggal_kembali,
      );

      _allPeminjaman.add(peminjaman);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  void editPeminjaman(
    String id,
    String tanggal_pinjam,
    String tanggal_kembali,
    BuildContext context,
  ) {
    Peminjaman selectPlayer =
        _allPeminjaman.firstWhere((element) => element.id == id);
    selectPlayer.tanggal_pinjam = tanggal_pinjam;
    selectPlayer.tanggal_kembali = tanggal_kembali;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Berhasil diubah"),
        duration: Duration(seconds: 2),
      ),
    );
    notifyListeners();
  }

  void deletePlayer(String id, BuildContext context) {
    _allPeminjaman.removeWhere((element) => element.id == id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Berhasil dihapus"),
        duration: Duration(milliseconds: 500),
      ),
    );
    notifyListeners();
  }

  Future<void> initializeData() async {
    Uri url = Uri.parse("http://localhost/pustaka/peminjaman.php");
    try {
      var hasilGetData = await http.get(url);
      var dataResponse = json.decode(hasilGetData.body) as Map<String, dynamic>;

      // Create Peminjaman objects from the response data
      final List<Peminjaman> loadedPeminjamans = [];
      dataResponse.forEach((key, value) {
        loadedPeminjamans.add(
          Peminjaman(
            id: value['id'],
            tanggal_pinjam: value['tanggal_pinjam'],
            tanggal_kembali: value['tanggal_kembali'],
          ),
        );
      });

      _allPeminjaman.clear();
      _allPeminjaman.addAll(loadedPeminjamans);

      print("BERHASIL MEMUAT DATA LIST");
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}

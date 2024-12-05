import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pustaka_oci/pages/add_buku.dart';
import 'package:http/http.dart' as http;
import '../models/buku.dart';

class Bukus with ChangeNotifier {
  final List<Buku> _allBuku = [];

  List<Buku> get allBuku => _allBuku;

  int get jumlahBuku => _allBuku.length;

  Buku selectById(String id) {
    return _allBuku.firstWhere((element) => element.id == id);
  }

  Future<void> addBuku(String judul_buku, String pengarang, String penerbit,
      String tahun_terbit) async {
    Uri url = Uri.parse("http://localhost/pustaka/buku.php/bukus");

    try {
      final response = await http.post(
        url,
        body: json.encode({
          "judul_buku": judul_buku,
          "pengarang": pengarang,
          "penerbit": penerbit,
          "tahun_terbit": tahun_terbit,
        }),
      );

      print("THEN FUNCTION");
      print(json.decode(response.body));

      final buku = Buku(
        id: json.decode(response.body)["id"],
        judul_buku: judul_buku,
        pengarang: pengarang,
        penerbit: penerbit,
        tahun_terbit: tahun_terbit,
      );

      _allBuku.add(buku);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  void editBuku(
    String id,
    String judul_buku,
    String pengarang,
    String penerbit,
    String tahun_terbit,
    BuildContext context,
  ) {
    Buku selectPlayer = _allBuku.firstWhere((element) => element.id == id);
    selectPlayer.judul_buku = judul_buku;
    selectPlayer.pengarang = pengarang;
    selectPlayer.penerbit = penerbit;
    selectPlayer.tahun_terbit = tahun_terbit;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Berhasil diubah"),
        duration: Duration(seconds: 2),
      ),
    );
    notifyListeners();
  }

  void deletePlayer(String id, BuildContext context) {
    _allBuku.removeWhere((element) => element.id == id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Berhasil dihapus"),
        duration: Duration(milliseconds: 500),
      ),
    );
    notifyListeners();
  }

  Future<void> initializeData() async {
    Uri url = Uri.parse("http://localhost/pustaka/buku.php");
    try {
      var hasilGetData = await http.get(url);
      var dataResponse = json.decode(hasilGetData.body) as Map<String, dynamic>;

      // Create Buku objects from the response data
      final List<Buku> loadedBukus = [];
      dataResponse.forEach((key, value) {
        loadedBukus.add(
          Buku(
            id: value['id'],
            judul_buku: value['judul_buku'],
            pengarang: value['pengarang'],
            penerbit: value['penerbit'],
            tahun_terbit: value['tahun_terbit'],
          ),
        );
      });

      _allBuku.clear();
      _allBuku.addAll(loadedBukus);

      print("BERHASIL MEMUAT DATA LIST");
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}

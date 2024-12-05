import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pustaka_oci/pages/add_pengembalian.dart';
import 'package:http/http.dart' as http;
import '../models/pengembalian.dart';

class Pengembalians with ChangeNotifier {
  final List<Pengembalian> _allPengembalian = [];

  List<Pengembalian> get allPengembalian => _allPengembalian;

  int get jumlahPengembalian => _allPengembalian.length;

  Pengembalian selectById(String id) {
    return _allPengembalian.firstWhere((element) => element.id == id);
  }

  Future<void> AddPengembalian(
      String tanggal_dikembalikan, String terlambat, String denda) async {
    Uri url =
        Uri.parse("http://localhost/pustaka/pengembalian.php/pengembalian");

    try {
      final response = await http.post(
        url,
        body: json.encode({
          "tanggal_dikembalikan": tanggal_dikembalikan,
          "terlambat": terlambat,
          "denda": denda,
        }),
      );

      print("THEN FUNCTION");
      print(json.decode(response.body));

      final pengembalian = Pengembalian(
        id: json.decode(response.body)["id"],
        tanggal_dikembalikan: tanggal_dikembalikan,
        terlambat: terlambat,
        denda: denda,
      );

      _allPengembalian.add(pengembalian);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  void editPengembalian(
    String id,
    String tanggal_dikembalikan,
    String terlambat,
    String denda,
    BuildContext context,
  ) {
    Pengembalian selectPlayer =
        _allPengembalian.firstWhere((element) => element.id == id);
    selectPlayer.tanggal_dikembalikan = tanggal_dikembalikan;
    selectPlayer.terlambat = terlambat;
    selectPlayer.denda = denda;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Berhasil diubah"),
        duration: Duration(seconds: 2),
      ),
    );
    notifyListeners();
  }

  void deletePlayer(String id, BuildContext context) {
    _allPengembalian.removeWhere((element) => element.id == id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Berhasil dihapus"),
        duration: Duration(milliseconds: 500),
      ),
    );
    notifyListeners();
  }

  Future<void> initializeData() async {
    Uri url = Uri.parse("http://localhost/pustaka/pengembalian.php");
    try {
      var hasilGetData = await http.get(url);
      var dataResponse = json.decode(hasilGetData.body) as Map<String, dynamic>;

      // Create pengembalian objects from the response data
      final List<Pengembalian> loadedPengembalians = [];
      dataResponse.forEach((key, value) {
        loadedPengembalians.add(
          Pengembalian(
            id: value['id'],
            tanggal_dikembalikan: value['tanggal_dikembalikan'],
            terlambat: value['terlambat'],
            denda: value['denda'],
          ),
        );
      });

      _allPengembalian.clear();
      _allPengembalian.addAll(loadedPengembalians);

      print("BERHASIL MEMUAT DATA LIST");
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }
}

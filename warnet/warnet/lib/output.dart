import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String kodePelanggan;
  final String namaPelanggan;
  final String jenisPelanggan;
  final String tglMasuk;
  final int jamMasuk;
  final int jamKeluar;

  const ResultPage({
    required this.kodePelanggan,
    required this.namaPelanggan,
    required this.jenisPelanggan,
    required this.tglMasuk,
    required this.jamMasuk,
    required this.jamKeluar,
  });

  @override
  Widget build(BuildContext context) {
    int tarifPerJam = 10000;
    int lama = (jamKeluar - jamMasuk) ~/ 60;
    double diskon = 0;

    if (jenisPelanggan == "VIP" && lama > 2) {
      diskon = 0.02 * tarifPerJam * lama;
    } else if (jenisPelanggan == "GOLD" && lama > 2) {
      diskon = 0.05 * tarifPerJam * lama;
    }

    double totalBayar = (lama * tarifPerJam) - diskon;

    return Scaffold(
      appBar: AppBar(
        title: Text('HASIL PEMBAYARAN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kode Pelanggan: $kodePelanggan'),
            Text('Nama Pelanggan: $namaPelanggan'),
            Text('Jenis Pelanggan: $jenisPelanggan'),
            Text('Tgl Masuk: $tglMasuk'),
            Text('Jam Masuk: ${jamMasuk ~/ 60}:${jamMasuk % 60}'),
            Text('Jam Keluar: ${jamKeluar ~/ 60}:${jamKeluar % 60}'),
            SizedBox(height: 20),
            Text('Lama Waktu: $lama jam'),
            Text('Tarif/Jam: Rp$tarifPerJam'),
            Text('Diskon: Rp${diskon.toStringAsFixed(0)}'),
            SizedBox(height: 20),
            Text('Total Bayar: Rp${totalBayar.toStringAsFixed(0)}'),
          ],
        ),
      ),
    );
  }
}

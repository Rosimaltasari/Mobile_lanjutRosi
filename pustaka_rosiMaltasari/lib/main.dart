import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pustaka_oci/drawer.dart';
import 'package:pustaka_oci/pages/detail_peminjaman.dart';
import 'package:pustaka_oci/pages/home_peminjaman.dart';

import 'pages/home_anggota.dart';
import 'pages/add_anggota.dart';
import 'pages/detail_anggota.dart';

import 'pages/home_buku.dart';
import 'pages/add_buku.dart';
import 'pages/detail_buku.dart';

import 'pages/home_pengembalian.dart'; // Halaman pengembalian
import 'pages/add_pengembalian.dart'; // Halaman tambah pengembalian
import 'pages/detail_pengembalian.dart'; // Halaman detail pengembalian

import 'pages/add_peminjaman.dart';

import 'providers/anggotas.dart';
import 'providers/bukus.dart';
import 'providers/peminjamans.dart'; // Tambahkan provider peminjaman
import 'providers/pengembalians.dart'; // Tambahkan provider pengembalian

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Anggotas()),
        ChangeNotifierProvider(create: (context) => Bukus()),
        ChangeNotifierProvider(create: (context) => Peminjamans()),
        ChangeNotifierProvider(
            create: (context) => Pengembalians()), // Provider pengembalian
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        routes: {
          HomeAnggota.routeName: (context) => HomeAnggota(),
          HomeBuku.routeName: (context) => HomeBuku(),
          HomePeminjaman.routeName: (context) => HomePeminjaman(),
          HomePengembalian.routeName: (context) => HomePengembalian(),
          DetailAnggota.routeName: (context) => DetailAnggota(),
          DetailBuku.routeName: (context) => DetailBuku(),
          DetailPeminjaman.routeName: (context) => DetailPeminjaman(),
          DetailPengembalian.routeName: (context) => DetailPengembalian(),
          AddAnggota.routeName: (context) => AddAnggota(),
          AddBuku.routeName: (context) => AddBuku(),
          AddPeminjaman.routeName: (context) => AddPeminjaman(),
          AddPengembalian.routeName: (context) =>
              AddPengembalian(), // Halaman detail pengembalian
        },
      ),
    );
  }
}

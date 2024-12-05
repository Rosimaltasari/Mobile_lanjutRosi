import 'package:flutter/material.dart';
import 'package:pustaka_oci/models/anggota.dart';
import 'package:pustaka_oci/models/buku.dart';
import 'package:pustaka_oci/models/peminjaman.dart';
import 'package:pustaka_oci/models/pengembalian.dart';
import 'package:pustaka_oci/pages/home_anggota.dart';
import 'package:pustaka_oci/pages/home_buku.dart';
import 'package:pustaka_oci/pages/home_peminjaman.dart';
import 'package:pustaka_oci/pages/home_pengembalian.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawer Navigation',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MENU PILIHAN"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                "MENU PUSTAKA ROSI",
                style: TextStyle(fontSize: 24),
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(HomeAnggota.routeName);
              },
              leading: Icon(Icons.home),
              title: Text("Anggota"),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(HomeBuku.routeName);
              },
              leading: Icon(Icons.home),
              title: Text("Buku"),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(HomePeminjaman.routeName);
              },
              leading: Icon(Icons.home),
              title: Text("PEMINJAMAN"),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).pushNamed(HomePengembalian.routeName);
              },
              leading: Icon(Icons.home),
              title: Text("PENGEMBALIAN"),
            ),
          ],
        ),
      ),
    );
  }
}

class PageSatu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page 1"),
      ),
      body: Center(
        child: Text("Ini Page 1"),
      ),
    );
  }
}

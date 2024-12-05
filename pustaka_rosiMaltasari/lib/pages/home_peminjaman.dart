import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/peminjamans.dart';
import 'add_peminjaman.dart';
import 'detail_peminjaman.dart';

class HomePeminjaman extends StatefulWidget {
  static const routeName = '/home-peminjaman';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePeminjaman> {
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Peminjamans>(context).initializeData();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final allPeminjamanProvider = Provider.of<Peminjamans>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("ALL PEMINJAMAN"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AddPeminjaman.routeName);
            },
          ),
        ],
      ),
      body: allPeminjamanProvider.allPeminjaman.length == 0
          ? Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No Data",
                    style: TextStyle(fontSize: 25),
                  ),
                  SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AddPeminjaman.routeName);
                    },
                    child: Text(
                      "Add Peminjaman",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: allPeminjamanProvider.allPeminjaman.length,
              itemBuilder: (context, index) {
                var id = allPeminjamanProvider.allPeminjaman[index].id;
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      DetailPeminjaman.routeName,
                      arguments: id,
                    );
                  },
                  title: Text(
                    allPeminjamanProvider.allPeminjaman[index].tanggal_pinjam,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      allPeminjamanProvider.deletePlayer(id, context);
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            ),
    );
  }
}

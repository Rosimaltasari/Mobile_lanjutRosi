import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bukus.dart';
import 'add_buku.dart';
import 'detail_buku.dart';

class HomeBuku extends StatefulWidget {
  static const routeName = '/home-buku';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeBuku> {
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Bukus>(context).initializeData();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final allBukuProvider = Provider.of<Bukus>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("ALL Buku"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AddBuku.routeName);
            },
          ),
        ],
      ),
      body: allBukuProvider.allBuku.length == 0
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
                      Navigator.pushNamed(context, AddBuku.routeName);
                    },
                    child: Text(
                      "Add Buku",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: allBukuProvider.allBuku.length,
              itemBuilder: (context, index) {
                var id = allBukuProvider.allBuku[index].id;
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      DetailBuku.routeName,
                      arguments: id,
                    );
                  },
                  title: Text(
                    allBukuProvider.allBuku[index].judul_buku,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      allBukuProvider.deletePlayer(id, context);
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            ),
    );
  }
}

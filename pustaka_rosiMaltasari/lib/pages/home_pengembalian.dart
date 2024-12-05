import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pengembalians.dart';
import 'add_pengembalian.dart';
import 'detail_pengembalian.dart';

class HomePengembalian extends StatefulWidget {
  static const routeName = '/home-pengembalian';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePengembalian> {
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Pengembalians>(context).initializeData();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final allPengembalianProvider = Provider.of<Pengembalians>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("ALL PENEMBALIAN"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AddPengembalian.routeName);
            },
          ),
        ],
      ),
      body: allPengembalianProvider.allPengembalian.length == 0
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
                      Navigator.pushNamed(context, AddPengembalian.routeName);
                    },
                    child: Text(
                      "Add Pengembalian",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: allPengembalianProvider.allPengembalian.length,
              itemBuilder: (context, index) {
                var id = allPengembalianProvider.allPengembalian[index].id;
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      DetailPengembalian.routeName,
                      arguments: id,
                    );
                  },
                  title: Text(
                    allPengembalianProvider
                        .allPengembalian[index].tanggal_dikembalikan,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      allPengembalianProvider.deletePlayer(id, context);
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            ),
    );
  }
}

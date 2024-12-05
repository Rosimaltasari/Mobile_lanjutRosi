import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anggotas.dart';
import 'add_anggota.dart';
import 'detail_anggota.dart';

class HomeAnggota extends StatefulWidget {
  static const routeName = '/home-anggota';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeAnggota> {
  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Anggotas>(context).initializeData();
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final allAnggotaProvider = Provider.of<Anggotas>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("ALL ANGGOTA"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AddAnggota.routeName);
            },
          ),
        ],
      ),
      body: allAnggotaProvider.allAnggota.length == 0
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
                      Navigator.pushNamed(context, AddAnggota.routeName);
                    },
                    child: Text(
                      "Add Anggota",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: allAnggotaProvider.allAnggota.length,
              itemBuilder: (context, index) {
                var id = allAnggotaProvider.allAnggota[index].id;
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      DetailAnggota.routeName,
                      arguments: id,
                    );
                  },
                  title: Text(
                    allAnggotaProvider.allAnggota[index].nim_anggota,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      allAnggotaProvider.deletePlayer(id, context);
                    },
                    icon: Icon(Icons.delete),
                  ),
                );
              },
            ),
    );
  }
}

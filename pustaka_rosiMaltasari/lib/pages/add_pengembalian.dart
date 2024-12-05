import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pustaka_oci/models/pengembalian.dart';
import '../providers/pengembalians.dart';

class AddPengembalian extends StatelessWidget {
  static const routeName = '/add-pengembalian';

  final TextEditingController tanggal_dikembalikanController =
      TextEditingController();
  final TextEditingController terlambatController = TextEditingController();
  final TextEditingController dendaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final players = Provider.of<Pengembalians>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("ADD Pengembalian"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              players.AddPengembalian(
                tanggal_dikembalikanController.text,
                terlambatController.text,
                dendaController.text,
              ).then(
                (response) {
                  print("Kembali ke home & kasih notif snack bar");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Berhasil ditambahkan"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pop(context);
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                autocorrect: false,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Tanggal dikembalikan",
                ),
                textInputAction: TextInputAction.next,
                controller: tanggal_dikembalikanController,
              ),
              TextFormField(
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "terlambat",
                ),
                textInputAction: TextInputAction.next,
                controller: terlambatController,
              ),
              TextFormField(
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "denda",
                ),
                textInputAction: TextInputAction.done,
                controller: dendaController,
                onEditingComplete: () {
                  players.AddPengembalian(tanggal_dikembalikanController.text,
                          terlambatController.text, dendaController.text)
                      .then(
                    (response) {
                      print("Kembali ke home & kasih notif snack bar");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Berhasil ditambahkan"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    players.AddPengembalian(
                      tanggal_dikembalikanController.text,
                      terlambatController.text,
                      dendaController.text,
                    ).then(
                      (response) {
                        print("Kembali ke home & kasih notif snack bar");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Berhasil ditambahkan"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        Navigator.pop(context);
                      },
                    );
                  },
                  child: Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

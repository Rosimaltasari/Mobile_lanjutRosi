import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pustaka_oci/models/peminjaman.dart';
import '../providers/peminjamans.dart';

class AddPeminjaman extends StatelessWidget {
  static const routeName = '/add-peminjaman';

  final TextEditingController tanggal_pinjamController =
      TextEditingController();
  final TextEditingController tanggal_kembaliController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final players = Provider.of<Peminjamans>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("ADD Peminjaman"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              players.AddPeminjaman(
                tanggal_pinjamController.text,
                tanggal_kembaliController.text,
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
                  labelText: "Tanggal Pinjam",
                ),
                textInputAction: TextInputAction.next,
                controller: tanggal_pinjamController,
              ),
              TextFormField(
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Tanggal Kembali",
                ),
                onEditingComplete: () {
                  players.AddPeminjaman(
                    tanggal_pinjamController.text,
                    tanggal_kembaliController.text,
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
              SizedBox(height: 20),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    players.AddPeminjaman(
                      tanggal_pinjamController.text,
                      tanggal_kembaliController.text,
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pustaka_oci/models/buku.dart';
import '../providers/bukus.dart';

class AddBuku extends StatelessWidget {
  static const routeName = '/add-buku';

  final TextEditingController judul_bukuController = TextEditingController();
  final TextEditingController pengarangController = TextEditingController();
  final TextEditingController penerbitController = TextEditingController();
  final TextEditingController tahun_terbitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final players = Provider.of<Bukus>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("ADD Buku"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              players
                  .addBuku(
                judul_bukuController.text,
                pengarangController.text,
                penerbitController.text,
                tahun_terbitController.text,
              )
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
                  labelText: "Judul Buku",
                ),
                textInputAction: TextInputAction.next,
                controller: judul_bukuController,
              ),
              TextFormField(
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Pengarang",
                ),
                textInputAction: TextInputAction.next,
                controller: pengarangController,
              ),
              TextFormField(
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Penerbit",
                ),
                textInputAction: TextInputAction.done,
                controller: penerbitController,
              ),
              TextFormField(
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Tahun Terbit",
                ),
                textInputAction: TextInputAction.done,
                controller: tahun_terbitController,
                onEditingComplete: () {
                  players
                      .addBuku(
                    judul_bukuController.text,
                    pengarangController.text,
                    penerbitController.text,
                    tahun_terbitController.text,
                  )
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
                    players
                        .addBuku(
                      judul_bukuController.text,
                      pengarangController.text,
                      penerbitController.text,
                      tahun_terbitController.text,
                    )
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

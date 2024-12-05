import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pustaka_oci/models/anggota.dart';
import '../providers/anggotas.dart';

class AddAnggota extends StatelessWidget {
  static const routeName = '/add-anggota';

  final TextEditingController nim_anggotaController = TextEditingController();
  final TextEditingController nama_anggotaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController jenis_kelaminController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final players = Provider.of<Anggotas>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("ADD Anggota"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              players
                  .addAnggota(
                nim_anggotaController.text,
                nama_anggotaController.text,
                alamatController.text,
                jenis_kelaminController.text,
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
                  labelText: "Nim",
                ),
                textInputAction: TextInputAction.next,
                controller: nim_anggotaController,
              ),
              TextFormField(
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Nama",
                ),
                textInputAction: TextInputAction.next,
                controller: nama_anggotaController,
              ),
              TextFormField(
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "alamat",
                ),
                textInputAction: TextInputAction.done,
                controller: alamatController,
              ),
              TextFormField(
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "jenis kelamin",
                ),
                textInputAction: TextInputAction.done,
                controller: jenis_kelaminController,
                onEditingComplete: () {
                  players
                      .addAnggota(
                    nim_anggotaController.text,
                    nama_anggotaController.text,
                    alamatController.text,
                    jenis_kelaminController.text,
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
                        .addAnggota(
                      nim_anggotaController.text,
                      nama_anggotaController.text,
                      alamatController.text,
                      jenis_kelaminController.text,
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

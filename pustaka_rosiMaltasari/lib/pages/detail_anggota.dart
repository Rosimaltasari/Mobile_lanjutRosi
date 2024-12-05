import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/anggotas.dart';

class DetailAnggota extends StatelessWidget {
  static const routeName = '/detail-anggota';

  @override
  Widget build(BuildContext context) {
    final anggotas = Provider.of<Anggotas>(context, listen: false);
    final anggotaId = ModalRoute.of(context)!.settings.arguments as String;
    final selectAnggota = anggotas.selectById(anggotaId);

    final TextEditingController nim_anggotaController =
        TextEditingController(text: selectAnggota.nim_anggota);
    final TextEditingController nama_anggotaController =
        TextEditingController(text: selectAnggota.nama_anggota);
    final TextEditingController alamatController =
        TextEditingController(text: selectAnggota.alamat);
    final TextEditingController jenis_kelaminController =
        TextEditingController(text: selectAnggota.jenis_kelamin);

    return Scaffold(
      appBar: AppBar(
        title: Text("DETAIL ANGGOTA"),
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
                  labelText: "Alamat",
                ),
                textInputAction: TextInputAction.done,
                controller: alamatController,
              ),
              TextFormField(
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Jenis kelamin",
                ),
                textInputAction: TextInputAction.done,
                controller: jenis_kelaminController,
                onEditingComplete: () {
                  anggotas.editAnggota(
                    anggotaId,
                    nim_anggotaController.text,
                    nama_anggotaController.text,
                    alamatController.text,
                    jenis_kelaminController.text,
                    context,
                  );
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 50),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    anggotas.editAnggota(
                      anggotaId,
                      nim_anggotaController.text,
                      nama_anggotaController.text,
                      alamatController.text,
                      jenis_kelaminController.text,
                      context,
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    "EDIT",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

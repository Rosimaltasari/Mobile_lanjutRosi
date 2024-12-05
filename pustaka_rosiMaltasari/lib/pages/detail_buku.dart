import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bukus.dart';

class DetailBuku extends StatelessWidget {
  static const routeName = '/detail-buku';

  @override
  Widget build(BuildContext context) {
    final bukus = Provider.of<Bukus>(context, listen: false);
    final bukuId = ModalRoute.of(context)!.settings.arguments as String;
    final selectBuku = bukus.selectById(bukuId);

    final TextEditingController judul_bukuController =
        TextEditingController(text: selectBuku.judul_buku);
    final TextEditingController pengarangController =
        TextEditingController(text: selectBuku.pengarang);
    final TextEditingController penerbitController =
        TextEditingController(text: selectBuku.penerbit);
    final TextEditingController tahun_terbitController =
        TextEditingController(text: selectBuku.tahun_terbit);

    return Scaffold(
      appBar: AppBar(
        title: Text("DETAIL BUKU"),
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
                  labelText: "Judul buku",
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
                  bukus.editBuku(
                    bukuId,
                    judul_bukuController.text,
                    pengarangController.text,
                    penerbitController.text,
                    tahun_terbitController.text,
                    context,
                  );
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 50),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    bukus.editBuku(
                      bukuId,
                      judul_bukuController.text,
                      pengarangController.text,
                      penerbitController.text,
                      tahun_terbitController.text,
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

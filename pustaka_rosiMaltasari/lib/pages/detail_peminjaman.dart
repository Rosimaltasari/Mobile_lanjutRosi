import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/peminjamans.dart';

class DetailPeminjaman extends StatelessWidget {
  static const routeName = '/detail-peminjaman';

  @override
  Widget build(BuildContext context) {
    final peminjamans = Provider.of<Peminjamans>(context, listen: false);
    final peminjamanId = ModalRoute.of(context)!.settings.arguments as String;
    final selectPeminjaman = peminjamans.selectById(peminjamanId);

    final TextEditingController tanggal_pinjamController =
        TextEditingController(text: selectPeminjaman.tanggal_pinjam);
    final TextEditingController tanggal_kembaliController =
        TextEditingController(text: selectPeminjaman.tanggal_kembali);

    return Scaffold(
      appBar: AppBar(
        title: Text("DETAIL PEMINJAMAN"),
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
                  labelText: "Tanggal pinjam",
                ),
                textInputAction: TextInputAction.next,
                controller: tanggal_pinjamController,
              ),
              TextFormField(
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Tanggal_kembali",
                ),
                textInputAction: TextInputAction.next,
                controller: tanggal_kembaliController,
                onEditingComplete: () {
                  peminjamans.editPeminjaman(
                    peminjamanId,
                    tanggal_pinjamController.text,
                    tanggal_kembaliController.text,
                    context,
                  );
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 50),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    peminjamans.editPeminjaman(
                      peminjamanId,
                      tanggal_pinjamController.text,
                      tanggal_kembaliController.text,
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

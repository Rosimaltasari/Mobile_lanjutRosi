import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pengembalians.dart';

class DetailPengembalian extends StatelessWidget {
  static const routeName = '/detail-pengembalian';

  @override
  Widget build(BuildContext context) {
    final pengembalians = Provider.of<Pengembalians>(context, listen: false);
    final pengembalianId = ModalRoute.of(context)!.settings.arguments as String;
    final selectPengembalian = pengembalians.selectById(pengembalianId);

    final TextEditingController tanggal_dikembalikanController =
        TextEditingController(text: selectPengembalian.tanggal_dikembalikan);
    final TextEditingController terlambatController =
        TextEditingController(text: selectPengembalian.terlambat);
    final TextEditingController dendaController =
        TextEditingController(text: selectPengembalian.denda);

    return Scaffold(
      appBar: AppBar(
        title: Text("DETAIL PENGEMBALIAN"),
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
                  pengembalians.editPengembalian(
                    pengembalianId,
                    tanggal_dikembalikanController.text,
                    terlambatController.text,
                    dendaController.text,
                    context,
                  );
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 50),
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    pengembalians.editPengembalian(
                      pengembalianId,
                      tanggal_dikembalikanController.text,
                      terlambatController.text,
                      dendaController.text,
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

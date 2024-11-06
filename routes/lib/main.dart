import 'package:flutter/material.dart';
import 'package:routes/galery_page.dart';
import 'package:routes/home_page.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainApp(),
      routes: {
        '/homePage': (context) => HomePage(),
        '/gallerypage': (context) => GalleryPage(),
      },
    );
  }
}

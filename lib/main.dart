import 'package:flutter/material.dart';
import 'package:ocr_sample/ocr_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCR Sample',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OCRPage(),
    );
  }
}

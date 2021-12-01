import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:ocr_sample/error_box.dart';
import 'package:ocr_sample/image_input.dart';

class OCRPage extends StatefulWidget {
  const OCRPage({Key? key}) : super(key: key);

  @override
  _OCRPageState createState() => _OCRPageState();
}

class _OCRPageState extends State<OCRPage> {
  String? capturedText;
  List<Barcode>? barcodes;
  bool firstRun = true;

  @override
  Widget build(BuildContext context) {
    if (barcodes != null) {
      if (barcodes!.isEmpty) barcodes = null;
    }
    if (capturedText != null) {
      if (capturedText!.isEmpty) capturedText = null;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR Sample'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ImageInput(processImage),
              ),
            ),
            const SizedBox(height: 20),
            if (capturedText != null)
              const Text('Captured Text',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (capturedText != null)
              Align(
                alignment: Alignment.center,
                child: Text(capturedText!),
              ),
            const SizedBox(height: 25),
            //for barcodes
            if (barcodes != null)
              const Text('Captured Barcodes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (barcodes != null)
              Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: barcodes!.map((barcode) {
                      return Text(barcode.rawValue!);
                    }).toList(),
                  )),
            const SizedBox(height: 15),
            ErrorBox((capturedText == null && barcodes == null && !firstRun)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void processImage(File imageFile) {
    final GoogleVisionImage visionImage = GoogleVisionImage.fromFile(imageFile);

    processBarcodes(visionImage);
    processText(visionImage);

  }

  void processText(GoogleVisionImage visionImage) async {
    final TextRecognizer textRecognizer =
        GoogleVision.instance.textRecognizer();

    capturedText=(await textRecognizer.processImage(visionImage)).text;
    textRecognizer.processImage(visionImage).then((value) {
      setState(() {
        firstRun = false;
        capturedText = value.text;
      });
    });
  }

  void processBarcodes(GoogleVisionImage visionImage) async {
    print('processing barcodes');
    final BarcodeDetector barcodeDetector =
        GoogleVision.instance.barcodeDetector();
    final List<Barcode> barcodes =
        await barcodeDetector.detectInImage(visionImage);
    setState(() {
      firstRun = false;
      if (barcodes.isEmpty) {
        this.barcodes = null;
      } else {
        this.barcodes = barcodes;
      }
    });
  }
}

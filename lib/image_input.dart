import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function processImageFile;

  const ImageInput(this.processImageFile,{Key? key}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> with WidgetsBindingObserver,SingleTickerProviderStateMixin {

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  Image? img;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 350),
      curve: Curves.fastOutSlowIn,
      child: _imageFile == null
          ? Container(
        width: MediaQuery.of(context).size.width * 0.7,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.indigo[900]!), borderRadius: BorderRadius.circular(20)),
        child: ElevatedButton(
          child: const Text('Add Photo'),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue[900])),
          onPressed: pickImage,
        ),
      )
          : Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.indigo[900]!)),
        height: img!.height,
        child: Column(
          children: [
            ClipRRect(borderRadius: const BorderRadius.vertical(top:Radius.circular(10)), child: img),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: const Text('Change photo'),
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.blue[900]),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    elevation: MaterialStateProperty.all(0),
                    shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),))
                ),
                onPressed: pickImage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pickImage() async {
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if(file==null) {
      return;
    }
    setState(() {
      _imageFile = File(file.path);
      img = Image.file(
        _imageFile!,
        fit: BoxFit.cover,
      );
    });
    widget.processImageFile(_imageFile);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _picker.retrieveLostData().then((value) {
          if (value.isEmpty) return;
          if (value.file != null) {
            setState(() {
              _imageFile = File(value.file!.path);
              img = Image.file(
                _imageFile!,
                fit: BoxFit.cover,
              );
            });
          }
          super.didChangeAppLifecycleState(state);
        });
        break;
      default: super.didChangeAppLifecycleState(state);
    }
  }
}
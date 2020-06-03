import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: path == null ? Text('No image selected.') : Text(path),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openImagePicker,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  void _openImagePicker() async {
    File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      print(' Attatchment- ${pick.path}');
//      path = pick.path;
      () {
        final StorageReference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('hello');
        final StorageUploadTask task = firebaseStorageRef.putFile(pick);
      };
    });
    String platformResponse;

    try {
      await ImagePicker.pickImage(source: ImageSource.gallery);
      platformResponse = 'success';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;
    print(platformResponse);
  }
}

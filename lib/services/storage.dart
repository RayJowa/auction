import 'dart:io';

import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {

  // final destination;
  StorageService();

  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();

  Future saveImage (String fileName, String itemId, File file) async {
    Reference? imagesRef = storageRef.child("images").child(itemId);

    final imgRef = imagesRef.child(fileName);

    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String filePath = '${appDocDir.absolute}/markets.png';
    // print(filePath);
    // File file = File(filePath);

    try {
      return await imgRef.putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e.toString());
    }

  }

  Future fetchImage() async {
    Reference? imagesRef = storageRef.child("images");
    final imgRef = imagesRef.child('fileName4');
    return await imgRef.getDownloadURL();
  }


}
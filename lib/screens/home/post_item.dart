import 'dart:io';

import 'package:auction/services/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostItem extends StatefulWidget {
  const PostItem({Key? key}) : super(key: key);

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {

  List<File> selectedImages = [];
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Item'),        
      ),
      body: Container(
        color: Colors.lightBlueAccent[50],
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                getImages();
              },
              child: Text('Pick Image')
            ),
            Text(
              '(Maximum 10 images)',
              style: TextStyle(
                color: Colors.blueAccent[150]
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: selectedImages.isEmpty
                  ? const Text('Nothing Selected')
                  : GridView.builder(
                      itemCount: selectedImages.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4
                      ),
                      addRepaintBoundaries:  true,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: Card(
                            child: kIsWeb
                                ? Image.network(selectedImages[index].path)
                                :Image.file(selectedImages[index])
                          )
                        );
                      },
                
                    )
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: () async {
                int count = 1;
                for (File image in selectedImages) {
                  await StorageService().saveImage(
                      'fileName$count',
                      'rray',
                      image
                  );
                  print('fileName$count saved');
                  count += 1;
                }
              },
              child: Text('Upload')
            )

            
          ],
        ),
      ),
      
    );
  }

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
      imageQuality: 100,
      maxHeight: 1000,
      maxWidth: 1000,

    );
    List<XFile>xFilePick = pickedFile;

    setState(() {
      if (xFilePick.length > 10) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text('Select a maximum of 10 images')),
              backgroundColor: Colors.redAccent,
            )
        );
      } else {
        if (xFilePick.isNotEmpty) {
          for (var i = 0; i < xFilePick.length; i++) {
            selectedImages.add(File(xFilePick[i].path));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(child: Text('Nothing selected')),
              )
          );
        }
      }
    });
  }
}



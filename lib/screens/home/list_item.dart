import 'dart:ffi';
import 'dart:io';

import 'package:auction/models/user.dart';
import 'package:auction/services/database.dart';
import 'package:auction/screens/shared/constants.dart';
import 'package:auction/services/storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ListItem extends StatefulWidget {
  const ListItem({Key? key}) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {

  final _formKey = GlobalKey<FormState>();

  String _title = '';
  String _description = '';
  String _bidStartPrice = '';
  String _reserve = '';
  String _address = '';
  String _phone = '';

  List<File> selectedImages = [];
  final picker = ImagePicker();
  List<String> imageFiles = [];

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AuctionUser?>(context);

    void _showPics(img) {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                //to show image, you type like this.
                img,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: 300,
              ),
            );

          }
      );
    }

    //Multple image picker config
    var configs = ImagePickerConfigs();
    configs.appBarTextColor = Colors.grey[300];
    configs.appBarBackgroundColor = Colors.black54;
    configs.doneButtonStyle = DoneButtonStyle.outlinedButton;
    configs.stickerFeatureEnabled = false; // ON/OFF features
    configs.translateFunc = (name, value) => Intl.message(value, name: name);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'List Item',
          style: const GoogleFonts.poppins(),
        ),
      ),
      body: SingleChildScrollView(

        child: Container(
          width: double.infinity,
          color: Colors.lightBlueAccent[50],
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(

                    children: [
                      TextFormField(
                        decoration: textnputDecoration.copyWith(
                          labelText: 'Item name',
                          hintText: 'Item name'
                        ),
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 2,
                        onChanged: (val) => setState(() {
                          _title = val;
                        }),
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        keyboardType: TextInputType.multiline,
                        minLines: 2,
                        maxLines: 3,
                        onChanged: (val) => setState(() {
                          _description = val;
                        }),
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (val) => setState(() {
                          _bidStartPrice = val;
                        }),
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(
                          signed: false,
                          decimal: false
                        ),
                        onChanged: (val) => setState(() {
                          _reserve = val;
                        }),
                      ),
                      const SizedBox(height: 50,),
                      const Text('Contact details'),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        onChanged: (val) => setState(() {
                          _phone = val;
                        }),
                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        keyboardType: TextInputType.streetAddress,
                        onChanged: (val) => setState(() {
                          _address = val;
                        }),
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed: () async {
                          dynamic result = await DatabaseService(uid: user!.uid)
                              .saveItem(
                              _title,
                              _description,
                              _bidStartPrice,
                              _reserve,
                              _address,
                              _phone,
                              selectedImages.length
                          );
                          print('==$result==============');

                          int count = 1;
                          for (File image in selectedImages) {
                            var res = await StorageService().saveImage(
                                'fileName$count',
                                result.id,
                                image
                            );
                            print('fileName$count saved');
                            print(result.toString());
                            print('===================');
                            count += 1;
                          }

                        },
                        child: SizedBox(width: 200, height: 50,)
                      )
                    ],
                  )
                ),

                ElevatedButton(
                  onPressed: () async {
                    List<ImageObject> objects =
                        await Navigator.of(context).push(
                        PageRouteBuilder(pageBuilder:
                            (context, animation, __) {
                          return ImagePicker(maxCount: 8);
                        }));

                    if (objects.length > 0) {
                      setState(() {
                        imageFiles.addAll(objects
                            .map((e) => e.modifiedPath)
                            .toList());
                        selectedImages = [];
                        for (String path in imageFiles ) {

                          selectedImages.add(File(path));
                        }
                      });
                    }

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
                Container(
                  constraints: BoxConstraints(maxHeight: 300),
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
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: kIsWeb
                              ? Image.network(
                                selectedImages[index].path,
                              fit: BoxFit.cover,
                              width: MediaQuery.of(context).size.width,
                              height: 100,
                            )
                                : Image.file(
                                  selectedImages[index],
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width,
                                  height: 100,
                                )
                          ),
                        ),

                      );
                    },

                  )
                ),

                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () async {
                    int count = 1;
                    for (File image in selectedImages) {
                      var result = await StorageService().saveImage(
                          'image$count',
                          'ray',

                          image
                      );
                      print('fileName$count saved');
                      print(result.toString());
                      print('===================');
                      count += 1;
                    }
                  },
                  child: Text('Upload')
                ),
                ElevatedButton(

                    onPressed: () async {
                      String img = await StorageService().fetchImage();
                      print(img);
                      _showPics(img);
                    },
                    child: Text('Show')
                )


              ],
            ),
          ),
        ),
      ),
      
    );
  }
}



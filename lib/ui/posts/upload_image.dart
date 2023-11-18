import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebasebackend/Widgets/roundButton.dart';
import 'package:firebasebackend/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  bool loading = false;

  File? _image;

  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');
  Future getGalleryImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Utils().sucesstoastMessage('No Image Picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getGalleryImage();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black,
                  )),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : Center(child: Icon(Icons.image)),
                ),
              ),
            ),
            SizedBox(
              height: 39,
            ),
            RoundButton(
                title: 'Upload',
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  firebase_storage.Reference ref =
                      firebase_storage.FirebaseStorage.instance.ref('/yousuf/' +
                          DateTime.now().millisecondsSinceEpoch.toString());
                  firebase_storage.UploadTask uploadTask =
                      ref.putFile(_image!.absolute);

                  Future.value(uploadTask).then((value) async {
                    var newUrl = await ref.getDownloadURL();

                    String id =
                        DateTime.now().microsecondsSinceEpoch.toString();

                    databaseRef.child(id).set(
                        {'id': id, 'Data': newUrl.toString()}).then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().sucesstoastMessage("$newUrl uploaded");
                    }).onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                    });
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                })
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:waste_food_manager/crud.dart';

class CreateBlogPage extends StatefulWidget {
  CreateBlogPage({Key key}) : super(key: key);

  @override
  _CreateBlogPageState createState() => _CreateBlogPageState();
}

class _CreateBlogPageState extends State<CreateBlogPage> {
  String organisationName, mobilenumber, description;
  File selectedimg;
  bool _isloading = false;
  CrudMethods crudMethods = CrudMethods();

  Future getImage() async {
    var pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectedimg = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  uploadData() async {
    print("print method called");
    if (selectedimg != null) {
      setState(() {
        _isloading = true;
      });
      Reference firebaseref = FirebaseStorage.instance
          .ref()
          .child("Posts")
          .child("${randomAlphaNumeric(9)}.jpg");
      final UploadTask task = firebaseref.putFile(selectedimg);
      var downloadurl = await (await task).ref.getDownloadURL();
      Map<String, String> post = {
        "orgname": organisationName,
        "descript": description,
        "mobile": mobilenumber,
        "imgurl":downloadurl,
      };
      crudMethods.addData(post).then((value) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Create",
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            Text(
              " Post",
              style: TextStyle(fontSize: 20, color: Colors.blue),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              uploadData();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(
                Icons.file_upload,
              ),
            ),
          )
        ],
      ),
      body: _isloading
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: selectedimg != null
                        ? Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),

                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            child: Image.file(
                              selectedimg,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            height: 150,
                            width: MediaQuery.of(context).size.width,
                            child: Icon(
                              Icons.add_a_photo,
                              color: Colors.black45,
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Organisation Name",
                          ),
                          onChanged: (val) {
                            organisationName = val;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Description",
                          ),
                          onChanged: (val) {
                            description = val;
                          },
                        ),
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Mobile",
                          ),
                          onChanged: (val) {
                            mobilenumber = val;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

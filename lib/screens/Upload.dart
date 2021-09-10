// import 'dart:html';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';

class Upload extends StatefulWidget {

  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  TextEditingController lecture=TextEditingController();
  TextEditingController lecturer=TextEditingController();

  File? image, song;
  String? imagepath, songpath;
  Reference? ref;
  var image_down_url, lecture_down_url;
  final firestoreinstance=FirebaseFirestore.instance;

  void selectimage()async{
    FilePickerResult? image = await FilePicker.platform.pickFiles();
    if(image != null) {
     File image= File(image.files.single.path);
      setState(() {
        imagepath=basename(image!.path);
        uploadimagefile(image!.readAsBytesSync(), imagepath!);
      });
    }
  }

  Future<void> uploadimagefile(image, String imagepath) async{
    ref=FirebaseStorage.instance.ref().child(imagepath);
    // StorageReference ref = FirebaseStorage().ref().child(imagepath);
    ref!.putFile(image);
    image_down_url=await ref!.getDownloadURL();
  }

  void selectsong() async{
    FilePickerResult? song = await FilePicker.platform.pickFiles(allowMultiple: true);
    setState(() {
      song=song;
      if(song != null) {
        List<File> files = song!.paths.map((path) => File(path!)).toList();
      } else {
        print('empty');
      }
      uploadsongfile(song!.files, songpath!);
    });

  }
  Future<void> uploadsongfile(song, String songpath) async{
    ref=FirebaseStorage.instance.ref().child(songpath);
    // StorageReference ref = FirebaseStorage().ref().child(imagepath);
    ref!.putFile(song);
    lecture_down_url=await ref!.getDownloadURL();
  }

  finalUpload(){
    var data= {
      "lecture_name": lecture.text,
      "lecturer_name": lecturer.text,
      "lecture_url": lecture_down_url.toString(),
      "image_url": image_down_url.toString(),
    };

    firestoreinstance.collection("lectures").doc().set(data);

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          RaisedButton(
            onPressed: ()=>selectimage(),
            child: Text("Select image"),
          ),
          RaisedButton(
            child: Text("Select lecture"),
            onPressed: ()=>selectsong(),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: TextField(
              controller: lecture,
              decoration: InputDecoration(
                hintText: "Enter lecture name",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            child: TextField(
              controller: lecturer,
              decoration: InputDecoration(
                hintText: "Enter lecturer name",
              ),
            ),
          ),
          RaisedButton(
            onPressed: ()=>finalUpload(),
            child: Text("Upload"),

          )
        ],
      ),
    );
  }
}

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class EditProfileScreen extends StatefulWidget {

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  File _image;
  String _uploadedFileURL;

  Future uploadFile() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser();
    if(firebaseUser!=null){
      StorageReference storageReference = FirebaseStorage.instance.ref()
          .child('profilePicture/${firebaseUser.uid}/ProfilePic ${Path.basename(_image.path)}');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.onComplete;
      print('File Uploaded');
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedFileURL = fileURL;

        });
      });
    }
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState((){
        _image = image;
        print("Image Path $image");
      });
    });
  }

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore File Upload'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Selected Image'),
            _image != null ? Image.asset(
              _image.path,
              height: 150,
            )
                : Container(height: 150),
            _image == null ?
            RaisedButton(
              child: Text('Choose File'),
              onPressed: chooseFile,
              color: Colors.cyan,
            )
                : Container(),
            _image != null ?
            RaisedButton(
              child: Text('Upload File'),
              onPressed: uploadFile,
              color: Colors.cyan,
            )
                : Container(),
            _image != null ?
            RaisedButton(
              child: Text('Clear Selection'),
              //onPressed: clearSelection,
            )
                : Container(),
            Text('Uploaded Image'),
            _uploadedFileURL != null ?
            Image.network(
              _uploadedFileURL,
              height: 150,
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}

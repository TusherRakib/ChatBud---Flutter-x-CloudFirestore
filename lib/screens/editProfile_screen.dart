import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messenger_clone/screens/profileScreen.dart';
import 'package:messenger_clone/services/database.dart';
import 'package:path/path.dart' as Path;
import '../helper/string_extension.dart';

class EditProfileScreen extends StatefulWidget {

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  String _blankImage = "";
  DatabaseMethods databaseMethods = new DatabaseMethods();

  String UserFirstName = "";
  String UserSecondName = "";
  String PhoneNumber = "";
  String BloodGroup = "";
  String Area = "";
  String City = "";
  String ProfilePic = "";
  String Password = "";

  String firstName;
  String secondName;
  String number;
  String area;
  String city;
  String pic;
  String pass;

  @override
  void initState() {
    _blankImage = 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png';
    setData();
    super.initState();
  }


  final formKey = GlobalKey<FormState>();

  TextEditingController userFirstNameEditingController = new TextEditingController();
  TextEditingController userSecondNameEditingController = new TextEditingController();
  TextEditingController contactNoEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  TextEditingController confirmPasswordEditingController = new TextEditingController();
  String _chosenArea;
  String _chosenCity;


  bool isLoading = false;
  bool passObscure = true;
  bool conPassObscure = true;

  final picker = ImagePicker();

  final firebaseUser = FirebaseAuth.instance.currentUser();


  File _image;
  String _uploadedFileURL;

  Future setData() async {
    await databaseMethods.getUserProfileInfo().then((result){
      userFirstNameEditingController.text = result.data['FirstName'].cap;
      userSecondNameEditingController.text = result.data['SecondName'];
      PhoneNumber = result.data['ContactNo'];
      Area = result.data['Area'];
      City = result.data['City'];
      ProfilePic = result.data['userProfilePhoto'];
      Password = result.data['pass'];

      //userFirstNameEditingController.text = UserFirstName.toString().capitalize();
      //userSecondNameEditingController.text = UserSecondName.toString().capitalize();
      contactNoEditingController.text = PhoneNumber.toString();
      passwordEditingController.text = Password.toString();
      _chosenArea = Area.toString();
      _chosenCity = City.toString();


      firstName = userFirstNameEditingController.text.capitalize();
       secondName = userSecondNameEditingController.text.capitalize();
       number = contactNoEditingController.text;
       area =  _chosenArea;
       city = _chosenCity;
       pass = passwordEditingController.text;

    });
  }

  Future uploadFile() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser();
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
        print("Image Path $image");
      });
    });
    if(firebaseUser!=null){
      StorageReference storageReference = FirebaseStorage.instance.ref()
          .child('profilePicture/${firebaseUser.uid}/ProfilePic/ ${Path.basename(_image.path)}');
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

  Future updateProfile() async{
    Map<String,String> userDataMap = {
      "userProfilePhoto" : _uploadedFileURL,
      "pass" : pass.toString(),
      "FirstName" : firstName.toLowerCase(),
      "SecondName" : secondName.toLowerCase(),
      "ContactNo" : number.toString(),
      "Area" : area.toString(),
      "City" : city.toString(),
    };
    databaseMethods.updateProfile(userDataMap);
    print(_uploadedFileURL);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Update Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
          automaticallyImplyLeading: true,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),
            onPressed: ()
            {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: (){
                        uploadFile();
                      },
                      child: CircleAvatar(
                        backgroundImage:  NetworkImage( _uploadedFileURL != null? _uploadedFileURL:
                          _blankImage,
                        ),
                        radius: 60.0,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: TextFormField(
                            validator: (val){
                              return val.isEmpty || val.length < 3 ? "Enter First Name 3+ characters" : null;
                            },
                            controller: userFirstNameEditingController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black45, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black45, width: 1.0),
                                ),
                                labelText: 'First Name',labelStyle: TextStyle(color: Colors.black45)
                            ),
                            onChanged: (value) {
                              firstName = value;
                            },
                          ),
                        ),
                        SizedBox(width: 20.0,),
                        Flexible(
                          child: TextFormField(
                            validator: (val){
                              return val.isEmpty || val.length < 3 ? "Enter Sur Name 3+ characters" : null;
                            },
                            controller: userSecondNameEditingController,
                            onChanged: (value) {
                              secondName = value;
                            },
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black45, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black45, width: 1.0),
                                ),
                                labelText: 'Sur Name',labelStyle: TextStyle(color: Colors.black45)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val){
                        return val.isEmpty || val.length < 11 ? "Contact No. is Incorrect" : null;
                      },
                      controller: contactNoEditingController,
                      onChanged: (value) {
                        number = value;
                      },
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45, width: 1.0),
                          ),
                          labelText: 'Contact No.',labelStyle: TextStyle(color: Colors.black45)),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          border: Border.all(color: Colors.black45)
                      ),
                      width: MediaQuery.of(context).size.width ,
                      height: MediaQuery.of(context).size.height/15,
                      child:  Padding(
                        padding: const EdgeInsets.only(left: 10.0,top: 17.0),
                        child: DropdownButtonFormField<String>(
                          focusColor:Colors.white,
                          value: _chosenArea,
                          elevation: 0,
                          decoration: InputDecoration.collapsed(hintText: ''),
                          style: TextStyle(color: Colors.white),
                          iconEnabledColor:Colors.black,
                          items: <String>['Shantinagar', 'Khilgaon', 'Jatrabari', 'Bashundhara', 'Gulshan', 'Mirpur', 'Mohammadpur', 'Farmgate',].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,style:TextStyle(color:Colors.black),),
                            );
                          }).toList(),
                          hint:Text(
                            "Choose Area",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              area = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          border: Border.all(color: Colors.black45)
                      ),
                      width: MediaQuery.of(context).size.width ,
                      height: MediaQuery.of(context).size.height/15,
                      child:  Padding(
                        padding: const EdgeInsets.only(left: 10.0,top: 17.0),
                        child: DropdownButtonFormField<String>(
                          focusColor:Colors.white,
                          value: _chosenCity,
                          elevation: 0,
                          decoration: InputDecoration.collapsed(hintText: ''),
                          style: TextStyle(color: Colors.white),
                          iconEnabledColor:Colors.black,
                          items: <String>['Dhaka',].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,style:TextStyle(color:Colors.black),),
                            );
                          }).toList(),
                          hint:Text(
                            "Choose City",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              city = value;
                            });
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val){
                        return val.length < 6 ? "Enter Password 6+ characters" : null;
                      },
                      onChanged: (value){
                        pass = value;
                      },
                      controller: passwordEditingController,
                      obscureText: passObscure == true? true: false,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              passObscure = !passObscure;
                              print("PASS PRESSED");
                            });
                          },
                            color:Colors.black,
                            icon: Icon(
                              passObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            )
                        ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45, width: 1.0),
                          ),
                          labelText: 'Password',labelStyle: TextStyle(color: Colors.black45)),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator:  (val){
                        return val.isEmpty? "Cannot be empty": val != passwordEditingController.text ? "Enter Password 6+ characters" : null;
                      },
                      controller: confirmPasswordEditingController,
                      obscureText: conPassObscure == true? true: false,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: (){
                                setState(() {
                                  conPassObscure = !conPassObscure;
                                  print("PASS PRESSED");
                                });
                              },
                              color:Colors.black,
                              icon: Icon(
                                conPassObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45, width: 1.0),
                          ),
                          labelText: 'Confirm Password',labelStyle: TextStyle(color: Colors.black45)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              GestureDetector(
                onTap: () async {
                  await updateProfile();
                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => ProfileScreen()));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text("Save",style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

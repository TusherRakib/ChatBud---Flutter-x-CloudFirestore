import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone/helper/constants.dart';
import 'package:messenger_clone/helper/helperfunctions.dart';
import 'package:messenger_clone/services/database.dart';
import 'package:messenger_clone/widgets/appbar_widget.dart';
import 'package:bottom_drawer/bottom_drawer.dart';

class ProfileScreen extends StatefulWidget {

  final String uid;
  ProfileScreen({this.uid});


  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot userResultSnapshot;

  String UserFirstName;
  String UserSecondName;
  String PhoneNumber;
  String EmailAddress;
  String BloodGroup;
  String Area;
  String city;

  @override
  void initState() {
    super.initState();
  }
  fetchUserData() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser != null) {
      await Firestore.instance
          .collection("users")
          .document(firebaseUser.uid)
          .get()
          .then((result) {
        EmailAddress = result.data['userEmail'];
        UserFirstName = result.data['FirstName'];
        UserSecondName = result.data['SecondName'];
        PhoneNumber = result.data['ContactNo'];
        BloodGroup = result.data['BloodGroup'];
        Area = result.data['Area'];
        city = result.data['City'];
      }).catchError((e) {
        print(e.toString());
      });
    }
  }

  BottomDrawerController controller = BottomDrawerController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: appBarMain(context),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            Center(
              child: CircleAvatar(
                radius: 60.0,
              ),
            ),
            Divider(
              height: 60.0,
              color: Colors.grey[800],
            ),
            Text(
              First,
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 10.0,),
            Text(
              'Rakib Tusher',
              style: TextStyle(
                color: Colors.amberAccent[200],
                letterSpacing: 2.0,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,

              ),
            ),
            SizedBox(height: 10.0,),
            Text(
              'CURRENT SKILL LEVEL',
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 10.0,),
            Text(
              '8',
              style: TextStyle(
                color: Colors.amberAccent[200],
                letterSpacing: 2.0,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,

              ),
            ),
            SizedBox(height: 10.0,),
            Row(
              children: <Widget>[
                Icon(
                  Icons.email,
                  color: Colors.grey[400],
                ),
                SizedBox(width: 10.0,),

                Text(
                  'Tusherrakib5@gmail.com',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 18.0,
                    letterSpacing: 2.0,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

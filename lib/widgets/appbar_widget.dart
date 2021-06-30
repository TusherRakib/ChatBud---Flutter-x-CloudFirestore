import 'package:flutter/material.dart';
import 'package:messenger_clone/screens/search_user.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Center(
      child: Text('ChatBud',
        style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.normal,
            fontFamily: "OverpassRegular"
        ),
      ),
    ),
    elevation: 0.0,
    centerTitle: false,
    actions: [
      IconButton(
        icon: Icon(Icons.search),
        iconSize: 30.0,
        color: Colors.white,
        onPressed: (){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchUser()));
        },
      ),
    ],
  );
}
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone/helper/authenticate.dart';
import 'package:messenger_clone/helper/helperfunctions.dart';
import 'package:messenger_clone/screens/chatroom_screen.dart';
import 'package:messenger_clone/screens/signIn_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn;

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn  = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Demo",
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Color(0xFFF3F3F3),

      ),
      home: userIsLoggedIn != null ?  userIsLoggedIn ? HomeScreen() : Authenticate()
          : Container(
        child: Center(
          child: Authenticate(),
        ),
      ),
    );
  }
}


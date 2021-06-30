import 'package:flutter/material.dart';
import 'package:messenger_clone/helper/authenticate.dart';
import 'package:messenger_clone/helper/constants.dart';
import 'package:messenger_clone/helper/helperfunctions.dart';
import 'package:messenger_clone/screens/conversation_screen.dart';
import 'package:messenger_clone/screens/profileScreen.dart';
import 'package:messenger_clone/screens/search_user.dart';
import 'package:messenger_clone/services/Auth.dart';
import 'package:messenger_clone/services/database.dart';
import 'package:messenger_clone/widgets/appbar_widget.dart';
import 'package:messenger_clone/widgets/category_selector.dart';
import 'package:messenger_clone/widgets/favContacts_widget.dart';
import '../helper/string_extension.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Stream chatRooms;
  Widget recentChats() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ChatRoomsTile(
                    userName: snapshot.data.documents[index].data['chatRoomId'].toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                    chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
                  );
                }) :
        Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0,left: 20.0),
            child: Text("Please Search for friends!",style: TextStyle(color: Colors.green),),
          ),
        );
      },
    );
  }

  Widget favContacts() {
    return StreamBuilder(
      stream: chatRooms,
      builder: (context, snapshot) {
        return snapshot.hasData ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return FavContacts(
                userName: snapshot.data.documents[index].data['chatRoomId'].toString().replaceAll("_", "").replaceAll(Constants.myName, ""),
                chatRoomId: snapshot.data.documents[index].data["chatRoomId"],
              );
            }) :
        Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0,left: 20.0),
            child: Center(child: Text("Please Search for friends!",style: TextStyle(color: Colors.green),)),
          ),
        );
        },
    );
  }

  @override
  void initState() {
    getUserInfogetChats();
    super.initState();
  }

  getUserInfogetChats() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    DatabaseMethods().getUserChats(Constants.myName).then((snapshots) {
      setState(() {
        chatRooms = snapshots;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:appBarMain(context),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0),topRight: Radius.circular(30.0))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget> [
            CategorySelector(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget> [
                  Text('Favorite Contacts ',
                    style: TextStyle(color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),),
                  IconButton(
                    onPressed: (){},
                    icon:
                    Icon(Icons.more_horiz),
                    iconSize: 30.0,
                    color: Colors.blueGrey,
                  )
                ],
              ),
            ),
            Container(
                height: 120.0,
                child: favContacts()
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text('Recent Chats ',
                style: TextStyle(color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0),),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: recentChats(),
              ),
            ),
            //RecentChats(),
          ],
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.redAccent,
              ),
              child: Image(image: AssetImage('images/Screenshot_7.png')),
            ),
            ListTile(
              title: Text('Profile',style: TextStyle(fontSize: 18.0,fontFamily: 'OverpassRegular'),),
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              title: Text('Sign Out',style: TextStyle(fontSize: 18.0,fontFamily: 'OverpassRegular'),),
              onTap: () {
                AuthService().signOut();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChatRoomsTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;

  ChatRoomsTile({this.userName,@required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Chat(
              userName: userName,
              chatRoomId: chatRoomId,
            )
        ));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0,left: 10.0,right: 10.0),
        child: Card(
          color: Color(0xFFDBE6FD),
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0,15.0,8.0,15.0),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Color(0xff007EF4),
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: Center(
                    child: Text(userName.substring(0, 1).toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'OverpassRegular',
                            fontWeight: FontWeight.w300)),
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Text(userName.capitalize(),
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
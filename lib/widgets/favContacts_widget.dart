import 'package:flutter/material.dart';
import 'package:messenger_clone/screens/conversation_screen.dart';
import '../helper/string_extension.dart';

class FavContacts extends StatelessWidget {



  final String userName;
  final String chatRoomId;
  FavContacts({this.userName,@required this.chatRoomId});

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
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Color(0xff007EF4),
                  borderRadius: BorderRadius.circular(30)),
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
    );;
  }
}

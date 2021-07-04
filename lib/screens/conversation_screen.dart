import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:messenger_clone/helper/constants.dart';
import 'package:messenger_clone/services/database.dart';
import '../helper/string_extension.dart';


class Chat extends StatefulWidget {

  final String userName;
  final String chatRoomId;
  Chat({this.chatRoomId, this.userName});


  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  

  ScrollController _scrollController = new ScrollController();
  Stream<QuerySnapshot> chats;
  TextEditingController messageEditingController = new TextEditingController();

  Widget chatMessages(){
    return StreamBuilder(
      stream: chats,
      builder: (context, snapshot){
        SchedulerBinding.instance.addPostFrameCallback((time) {_scrollController.jumpTo(_scrollController.position.maxScrollExtent); });
        return snapshot.hasData ?  ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sendByMe: Constants.myName == snapshot.data.documents[index].data["sendBy"],
              );
            }) : Container();
      },
    );
  }

  addMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": Constants.myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseMethods().addMessage(widget.chatRoomId, chatMessageMap);
      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    DatabaseMethods().getChats(widget.chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        title: Text(widget.userName.capitalize(),),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: Container(
        color: Theme.of(context).accentColor,
        child: Column(
          children: [
            Expanded(
              child: Container(
                  child: chatMessages()),
            ),
            Container(
              padding: EdgeInsets.all(15.0),
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      offset: Offset(0.0, 3.0), //(x,y)
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                //color: Color(0x54FFFFFF),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 8.0),
                          child: TextField(
                            controller: messageEditingController,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            decoration: InputDecoration(
                                hintText: "Message ...",
                                hintStyle: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none
                            ),
                          ),
                        )),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        addMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          child: Center(child: Icon(Icons.send))
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,

          left: sendByMe ? 0 : 15,
          right: sendByMe ? 15 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin: sendByMe
              ? EdgeInsets.only(left: 30)
              : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(
              top: 17, bottom: 17, left: 20, right: 20),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0.0, 3.0), //(x,y)
                  blurRadius: 3.0,
                ),
              ],
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            color: sendByMe? Colors.lightBlueAccent: Colors.white

      ),
      child: Text(message,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontFamily: 'OverpassRegular',
              fontWeight: FontWeight.w400)),
    ),
    );
  }
}

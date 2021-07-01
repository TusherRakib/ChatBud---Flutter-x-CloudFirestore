import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone/helper/constants.dart';
import 'package:messenger_clone/screens/conversation_screen.dart';
import 'package:messenger_clone/services/database.dart';
import '../helper/string_extension.dart';


class SearchUser extends StatefulWidget {

  @override
  _SearchUserState createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {

  TextEditingController searchEditingController = new TextEditingController();
  QuerySnapshot searchResultSnapshot;
  bool isLoading = false;
  bool haveUserSearched = false;
  DatabaseMethods databaseMethods = new DatabaseMethods();

  initiateSearch() async {
    if(searchEditingController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await databaseMethods.searchByName(searchEditingController.text.toLowerCase())
          .then((snapshot){
        searchResultSnapshot = snapshot;
        print("$searchResultSnapshot");
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      });
    }
  }
  Widget userList(){
    return haveUserSearched ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchResultSnapshot.documents.length,
        itemBuilder: (context, index){
          return userTile(
            searchResultSnapshot.documents[index].data["userName"],
            searchResultSnapshot.documents[index].data["userEmail"],
          );
        }) : Container();
  }

  sendMessage(String userName){
    List<String> users = [Constants.myName,userName];

    String chatRoomId = getChatRoomId(Constants.myName,userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };

    databaseMethods.addChatRoom(chatRoom, chatRoomId);

    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Chat(
          userName: userName,
          chatRoomId: chatRoomId,
        )
    ));

  }

  Widget userTile(String userName,String userEmail){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName.capitalize(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                ),
              ),
              SizedBox(height: 5.0,),
              Text(
                userEmail.capitalize(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              sendMessage(userName);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: Text("Message",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),),
            ),
          )
        ],
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        title: Text("Search User"),
        elevation: 0.0,
        centerTitle: false,
      ),
      body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) :  Container(
        height: 500.0,
        child: Column(
          children: [
            Material(
              elevation: 2,
              shadowColor: Colors.purple,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchEditingController,
                        //style: simpleTextStyle(),
                        decoration: InputDecoration(
                            hintText: "search username ...",
                            hintStyle: TextStyle(
                              color: Colors.black26,
                              fontSize: 16,
                            ),
                            border: InputBorder.none
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        initiateSearch();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FFFFFF),
                                    const Color(0x0FFFFFFF)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.search)),
                    )
                  ],
                ),
              ),
            ),
            userList()
          ],
        ),
      ),
    );
  }
}

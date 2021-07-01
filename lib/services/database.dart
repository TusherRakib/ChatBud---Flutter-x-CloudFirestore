import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {


  searchByName(String searchField) {
       return Firestore.instance
           .collection("users")
           .where('userName', isEqualTo: searchField)
           .getDocuments();
     }

  uploadUserInfo(userMap){
    Firestore.instance.collection("users")
        .add(userMap).catchError((e){
          print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return Firestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .getDocuments()
        .catchError((e) {
      print(e.toString());
    });
  }
  getProfileInfo(String uid) async {
    return Firestore.instance
        .collection("users")
        .document(uid).C
        .snapshots();
  }


  Future<bool> addChatRoom(chatRoom, chatRoomId) {
    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }
  //
  getChats(String chatRoomId) async{
    return Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }
  //

  Future<void> addMessage(String chatRoomId, chatMessageData){

    Firestore.instance.collection("chatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
          print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await Firestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

}

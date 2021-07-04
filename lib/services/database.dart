import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {

  final firebaseUser = FirebaseAuth.instance.currentUser();

  uploadUserInfo(userMap) async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    Firestore.instance
        .collection("users")
        .document(firebaseUser.uid)
        .setData(userMap)
        .catchError((e){
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

  // getUserProfileInfo() async {
  //   final FirebaseUser user = await FirebaseAuth.instance.currentUser();
  //   Firestore.instance
  //       .collection("users")
  //       .document(user.uid)
  //       .get();
  // }

  searchByName(String searchField) {
    return Firestore.instance
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .getDocuments();
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

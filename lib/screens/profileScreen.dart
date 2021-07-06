import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone/screens/chatroom_screen.dart';
import 'package:messenger_clone/screens/editProfile_screen.dart';
import 'package:messenger_clone/services/database.dart';
import '../helper/string_extension.dart';

class ProfileScreen extends StatefulWidget {

  @override
  _ProfileScreenState createState() => _ProfileScreenState();

}

class _ProfileScreenState extends State<ProfileScreen> {

  String UserFirstName = "";
  String UserSecondName = "";
  String PhoneNumber = "";
  String EmailAddress = "";
  String BloodGroup = "";
  String Area = "";
  String city = "";
  String ProfilePic = "";
  String emptyPhoto = "https://pngtree.com/freepng/profile-line-black-icon_4008141.html";

  bool isLoading = false;

  DatabaseMethods databaseMethods = new DatabaseMethods();

  @override
  void initState(){
    getUsersById();
    super.initState();
  }

  getUsersById() async {
    setState(() {
      isLoading = true;
    });

    final firebaseUser = await FirebaseAuth.instance.currentUser();
     if( firebaseUser !=null ){
       print("================================FIREBASE USER IS NOT NULL");
       await databaseMethods.getUserProfileInfo().then((result){
         EmailAddress = result.data['userEmail'];
         UserFirstName = result.data['FirstName'];
         UserSecondName = result.data['SecondName'];
         PhoneNumber = result.data['ContactNo'];
         BloodGroup = result.data['BloodGroup'];
         Area = result.data['Area'];
         city = result.data['City'];
         ProfilePic = result.data['userProfilePhoto'];
         setState(() {
           isLoading = false;
         });
       });
     }
  }

  get peopleCount => ["15","15","1155","3264"];
  final List<Color> cardColor = <Color>[Color(0xFFF3C583), Color(0xFFE99497),Color(0xFF1768AC),Color(0xFF843B8B)];
  get cardList => ["Buds","Favorite Bud"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
          onPressed: ()
          {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => HomeScreen()));
            },
        ),
        title: Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.edit),
            onPressed: ()
            {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()));
            },
          ),
        ],
      ),
       body:isLoading?
       Container(
         child: Center(child: CircularProgressIndicator()),
       ):SingleChildScrollView(
         physics: ScrollPhysics(),
         child: Padding(
           padding: const EdgeInsets.all(20.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Container(
                     height: 200.0,
                       width: 150.0,
                       decoration: BoxDecoration(
                         color: Colors.amber,
                         borderRadius: BorderRadius.all(Radius.circular(25.0))
                       ),
                       child: ProfilePic != null? Image.network(
                         ProfilePic,
                         height: 150,
                         fit: BoxFit.cover,
                       ): Center(child: Text("Empty")),

                   ),
                   SizedBox(width: 20.0,),
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Container(
                         width: MediaQuery.of(context).size.width/2.1,
                         child: Text("${UserFirstName.capitalize()} ${UserSecondName.capitalize()}",
                           style: TextStyle(
                           color: Colors.black,
                           fontSize: 30.0,
                           fontWeight: FontWeight.bold,
                           ),
                         ),
                       ),
                       SizedBox(height: 15,),
                       Container(
                           width: MediaQuery.of(context).size.width/2.1,
                           child: Text("Software Engineer",style: TextStyle(color: Colors.black45,fontSize: 20.0),)
                       ),
                       SizedBox(height: 8,),
                       Container(
                           width: MediaQuery.of(context).size.width/2.1,
                           child: Text("PencilTech Ltd.",style: TextStyle(color: Colors.black45,fontSize: 20.0),)
                       ),
                       SizedBox(height: 50,),
                       Container(
                         width: MediaQuery.of(context).size.width/2.5,
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Container(
                               height: 40.0,
                               width: 45.0,
                               decoration: BoxDecoration(
                                   color: Colors.amber.shade100,
                                   borderRadius: BorderRadius.all(Radius.circular(8.0))
                               ),
                               child: Icon(Icons.mail,color: Colors.amber,)
                             ),
                             Container(
                                 height: 40.0,
                                 width: 45.0,
                                 decoration: BoxDecoration(
                                     color: Colors.greenAccent.shade100,
                                     borderRadius: BorderRadius.all(Radius.circular(8.0))
                                 ),
                                 child: Icon(Icons.call,color: Colors.green,)
                             ),
                             Container(
                                 height: 40.0,
                                 width: 45.0,
                                 decoration: BoxDecoration(
                                     color: Colors.lightBlueAccent.shade100,
                                     borderRadius: BorderRadius.all(Radius.circular(8.0))
                                 ),
                                 child: Icon(Icons.sms,color: Colors.blue,)
                             ),
                           ],
                         ),
                       ),
                     ],
                   ),
                 ],
               ),
               SizedBox(height: 20.0,),
               Text("About",
                 style: TextStyle(
                   color: Colors.black,
                   fontSize: 18.0,
                   fontWeight: FontWeight.bold,
                 ),
               ),
               SizedBox(height: 5.0,),
               Text("Lorem Ipsum is simply dummy "
                   "text of the printing and typesetting industry. "
                   "Lorem Ipsum has been the industry's standard dummy "
                   "text ever since the 1500s, when an unknown printer took "
                   "a galley of type and scrambled it to make a type specimen book. "
                   "It has survived not only five centuries, ",
                 style: TextStyle(
                   color: Colors.black45,
                   fontSize: 15.0,
                   fontWeight: FontWeight.normal,
                 ),
               ),
               SizedBox(height: 20.0,),
               Text("Personal Information:",
                 style: TextStyle(
                 color: Colors.black,
                 fontSize: 20.0,
                 fontWeight: FontWeight.bold,
               ),),
               SizedBox(height: 10.0,),
               Padding(
                 padding: const EdgeInsets.only(left: 10.0),
                 child: Column(
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Text("Address:   ",
                           style: TextStyle(
                             color: Colors.black54,
                             fontSize: 20.0,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         Text("${Area.capitalize()} ${city.capitalize()}",
                           style: TextStyle(
                             color: Colors.black45,
                             fontSize: 18.0,
                             fontWeight: FontWeight.normal,
                           ),
                         ),
                       ],
                     ),
                     SizedBox(height: 10.0,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Text("Phone No. :   ",
                           style: TextStyle(
                             color: Colors.black54,
                             fontSize: 20.0,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         Text(PhoneNumber!=null? PhoneNumber: "Empty",
                           style: TextStyle(
                             color: Colors.black45,
                             fontSize: 18.0,
                             fontWeight: FontWeight.normal,
                           ),
                         ),
                       ],
                     ),
                     SizedBox(height: 10.0,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Text("Email Address:   ",
                           style: TextStyle(
                             color: Colors.black54,
                             fontSize: 20.0,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         Text(EmailAddress!=null?EmailAddress: "Empty",
                           style: TextStyle(
                             color: Colors.black45,
                             fontSize: 18.0,
                             fontWeight: FontWeight.normal,
                           ),
                         ),
                       ],
                     ),
                     SizedBox(height: 10.0,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Text("Blood Group:   ",
                           style: TextStyle(
                             color: Colors.black54,
                             fontSize: 20.0,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         Text(BloodGroup!=null?BloodGroup: "Empty",
                           style: TextStyle(
                             color: Colors.black45,
                             fontSize: 18.0,
                             fontWeight: FontWeight.normal,
                           ),
                         ),
                       ],
                     ),
                     SizedBox(height: 10.0,),
                   ],
                 ),
               ),
               Text("Activity",
                 style: TextStyle(
                 color: Colors.black,
                 fontSize: 20.0,
                 fontWeight: FontWeight.bold,
                 ),
               ),
               Container(
                 height: 170.0,
                 padding: EdgeInsets.only(top: 15.0),
                 child: GridView.builder(
                     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                         maxCrossAxisExtent: 200,
                         childAspectRatio: 1.3,
                         crossAxisSpacing: 10,
                         mainAxisSpacing: 10),
                     itemCount: cardList.length,
                     itemBuilder: (BuildContext ctx, index) {
                       return Container(
                         child: Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               CircleAvatar(
                                 child: Text(peopleCount[index],style: TextStyle(fontSize: 15.0,color: Colors.white)
                                 ),
                               ),
                               SizedBox(height: 10.0,),
                               Text(
                                 cardList[index],
                                 style: TextStyle(fontSize: 25.0,color: Colors.white),
                               ),
                             ],
                           ),
                         ),
                         decoration: BoxDecoration(
                             color: cardColor[index],
                             borderRadius: BorderRadius.circular(15)),
                       );
                     }),
               ),
               Container(
                 height: 80.0,
                 child: Padding(
                   padding: const EdgeInsets.only(top: 25.0),
                   child: ElevatedButton(
                       onPressed: () {
                         Navigator.push(
                             context, MaterialPageRoute(builder: (context) => EditProfileScreen()
                         ));
                       },
                       style: ElevatedButton.styleFrom(
                         primary: Colors.orangeAccent,
                       ),
                       child: Center(
                         child: Text('Edit Profile',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0,color: Colors.white),),
                       )
                   ),
                 ),
               ),
             ],
           ),
         ),
       )
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger_clone/helper/helperfunctions.dart';
import 'package:messenger_clone/screens/chatroom_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:messenger_clone/services/Auth.dart';
import 'package:messenger_clone/services/database.dart';


class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);


  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();
  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  HelperFunctions helperFunctions = new HelperFunctions();


  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  signIn() async {
    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      await authService.signInWithEmailAndPassword(emailEditingController.text.toLowerCase(), passwordEditingController.text.toLowerCase())
          .then((result) async {
        if (result != null)  {
          QuerySnapshot userInfoSnapshot =
          await DatabaseMethods().getUserInfo(emailEditingController.text.toLowerCase());

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data["userName"]);
          HelperFunctions.saveUserEmailSharedPreference(
              userInfoSnapshot.documents[0].data["userEmail"]);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));

        } else {
          setState(() {
            isLoading = false;
            //show snackbar
          });
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading?
      Container(
        child: Center(child: CircularProgressIndicator()),
      ):
      Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 130, 10, 10),
            child: Column(
              children: [
                Container(
                  color: Colors.transparent,
                    height: 210,
                    width: 200,
                    child: Image(image: AssetImage('images/Screenshot_7.png'))),
                SizedBox(height: 70),
                Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Material(
                        elevation: 2.0,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: TextFormField(
                            validator: (val){
                              return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                              null : "Enter correct email";
                            },
                            controller: emailEditingController,
                            decoration:
                            InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(
                                  Icons.mail,
                                  color: Colors.grey,
                                ),
                                hintText: 'Email'),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Material(
                        elevation: 2.0,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                          child: TextFormField(
                            validator:  (val){
                              return val.length < 6 ? "Enter Password 6+ characters" : null;
                            },
                            controller: passwordEditingController,
                            obscureText: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                                hintText: 'Password'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20.0),

                GestureDetector(
                  onTap: () {
                    signIn();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.red,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    height: 50,

                    width: MediaQuery.of(context).size.width,
                    child:  Center(
                        child: Text("Log In",style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 15,

                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Dont Have an Account?',
                        style: TextStyle(
                          fontSize: 15,

                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.toggle();
                        },
                        child: Text(
                          '  Register now!',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:messenger_clone/helper/authenticate.dart';
import 'package:messenger_clone/helper/helperfunctions.dart';
import 'package:messenger_clone/screens/chatroom_screen.dart';
import 'package:messenger_clone/screens/signIn_screen.dart';

import 'package:messenger_clone/services/Auth.dart';
import 'package:messenger_clone/services/database.dart';


class SignUp extends StatefulWidget {

  final Function toggle;

  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}
String checkpassword(String C){

}
class _SignUpState extends State<SignUp> {

  TextEditingController userNameEditingController = new TextEditingController();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;


  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  HelperFunctions helperFunctions = new HelperFunctions();

  signUp() async {

    if(formKey.currentState.validate()){
      Map<String,String> userDataMap = {
        "pass" : passwordEditingController.text,
        "userName" : userNameEditingController.text.toLowerCase(),
        "userEmail" : emailEditingController.text.toLowerCase()
      };

      HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(passwordEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(userNameEditingController.text);

      setState(() {
        isLoading = true;
      });

      await authService.signUpWithEmailAndPassword(emailEditingController.text.toLowerCase(),
          passwordEditingController.text.toLowerCase()).then((result){
            print("$result");
            databaseMethods.uploadUserInfo(userDataMap);
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => Authenticate()
            ));
      //   }
       });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: isLoading? Container(
        child: Center(child: CircularProgressIndicator()),
      ):
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 200, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Material(
                      elevation: 2.0,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                        child: TextFormField(
                          validator: (val){
                            return val.isEmpty || val.length < 3 ? "Enter Username 3+ characters" : null;
                          },
                          controller: userNameEditingController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                Icons.account_circle_outlined,
                                color: Colors.grey,
                              ),
                              hintText: 'Name'),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
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
                          decoration: InputDecoration(
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
              SizedBox(height: 30.0),
              GestureDetector(
                onTap: (){
                  signUp();
                },
                child: Container(
                  height: 50,
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
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text("Sign Up",style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),)),
                ),
              ),
              SizedBox(height: 30.0),
              //Text("OR",style: TextStyle(fontSize: 20.0),),
              GestureDetector(
                  onTap: () {
                    widget.toggle();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account?',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Text("LOG IN",
                        style: TextStyle(fontSize: 18.0,color: Colors.red),
                      ),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

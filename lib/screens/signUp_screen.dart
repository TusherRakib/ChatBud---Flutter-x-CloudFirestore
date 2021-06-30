import 'package:flutter/material.dart';
import 'package:messenger_clone/helper/authenticate.dart';
import 'package:messenger_clone/helper/helperfunctions.dart';
import 'package:messenger_clone/screens/chatroom_screen.dart';
import 'package:messenger_clone/screens/signIn_screen.dart';

import 'package:messenger_clone/services/Auth.dart';
import 'package:messenger_clone/services/database.dart';
import 'package:intl/intl.dart';


class SignUp extends StatefulWidget {

  final Function toggle;

  SignUp(this.toggle);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  // DateTime selectedDate;
  //
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != selectedDate)
  //     setState(() {
  //       selectedDate = picked;
  //     });
  // }

  TextEditingController userFirstNameEditingController = new TextEditingController();
  TextEditingController userSecondNameEditingController = new TextEditingController();
  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String _chosenValue;


  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  HelperFunctions helperFunctions = new HelperFunctions();

  signUp() async {
    if(formKey.currentState.validate()){
      Map<String,String> userDataMap = {
        "pass" : passwordEditingController.text,
        "userName" : userFirstNameEditingController.text.toLowerCase()+ userSecondNameEditingController.text.toLowerCase(),
        "userEmail" : emailEditingController.text.toLowerCase()
      };

      HelperFunctions.saveUserEmailSharedPreference(emailEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(passwordEditingController.text);
      HelperFunctions.saveUserEmailSharedPreference(userFirstNameEditingController.text);

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
    //String _formatDate = new DateFormat.yMMMd().format(_dateTime);
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: isLoading? Container(
        child: Center(child: CircularProgressIndicator()),
      ):
      SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 100, 15, 10),
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
              SizedBox(height: 30.0,),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: TextFormField(
                            validator: (val){
                            return val.isEmpty || val.length < 3 ? "Enter Username 3+ characters" : null;
                          },
                            controller: userFirstNameEditingController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black45, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black45, width: 1.0),
                                ),
                                labelText: 'First Name',labelStyle: TextStyle(color: Colors.black45)),
                          ),
                        ),
                        SizedBox(width: 20.0,),
                        Flexible(
                          child: TextFormField(
                            validator: (val){
                              return val.isEmpty || val.length < 3 ? "Enter Username 3+ characters" : null;
                            },
                            controller: userSecondNameEditingController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black45, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black45, width: 1.0),
                                ),
                               labelText: 'Sur Name',labelStyle: TextStyle(color: Colors.black45)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val){
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                        null : "Enter correct email";
                      },
                      controller: emailEditingController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45, width: 1.0),
                          ),
                          labelText: 'Contact No.',labelStyle: TextStyle(color: Colors.black45)),
                    ),
                    //SizedBox(height: 20.0),
                    //Text(_formatDate == null? "Nothing": _formatDate.toString()),

                    // Text("${selectedDate.toLocal()}".split(' ')[0]),
                    // SizedBox(height: 20.0,),
                    // ElevatedButton(
                    //   onPressed: () => _selectDate(context),
                    //   child: Text('Select date'),
                    // ),

                    // ElevatedButton(
                    //     onPressed: (){
                    //       showDatePicker(context: context,
                    //           initialDate: _formatDate == null? DateTime.now(): _formatDate,
                    //           firstDate: DateTime(2001),
                    //           lastDate: DateTime(2222)
                    //       ).then((date) {
                    //         setState(() {
                    //           _formatDate = date as String;
                    //         });
                    //       });
                    //     },
                    //     child: Text("Pick a date")
                    // ),
                    // TextFormField(
                    //   onTap: () => _selectDate(context),
                    //   validator: (val){
                    //     return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                    //     null : "Enter correct email";
                    //   },
                    //   controller: emailEditingController,
                    //   decoration: InputDecoration(
                    //       focusedBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.black45, width: 2.0),
                    //       ),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: Colors.black45, width: 1.0),
                    //       ),
                    //       labelText: 'BirthDate',labelStyle: TextStyle(color: Colors.black45)),
                    // ),
                    SizedBox(height: 20.0),

                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          border: Border.all(color: Colors.black45)
                      ),
                      width: MediaQuery.of(context).size.width ,
                      height: MediaQuery.of(context).size.height/15,
                      child:  Padding(
                        padding: const EdgeInsets.only(left: 10.0,top: 17.0),
                        child: DropdownButtonFormField<String>(
                          focusColor:Colors.white,
                          value: _chosenValue,
                          elevation: 0,
                          decoration: InputDecoration.collapsed(hintText: ''),
                          style: TextStyle(color: Colors.white),
                          iconEnabledColor:Colors.black,
                          items: <String>['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-',].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,style:TextStyle(color:Colors.black),),
                            );
                          }).toList(),
                          hint:Text(
                            "Blood Group",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _chosenValue = value;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val){
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                        null : "Enter correct email";
                      },
                      controller: emailEditingController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45, width: 1.0),
                          ),
                          labelText: 'BloodGroup',labelStyle: TextStyle(color: Colors.black45)),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val){
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                        null : "Enter correct email";
                      },
                      controller: emailEditingController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45, width: 1.0),
                          ),
                          labelText: 'Email',labelStyle: TextStyle(color: Colors.black45)),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val){
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ?
                        null : "Enter correct email";
                      },
                      controller: emailEditingController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45, width: 1.0),
                          ),
                          labelText: 'Password',labelStyle: TextStyle(color: Colors.black45)),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator:  (val){
                        return val.length < 6 ? "Enter Password 6+ characters" : null;
                      },
                      controller: passwordEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black45, width: 1.0),
                          ),
                          labelText: 'Confirm Password',labelStyle: TextStyle(color: Colors.black45)),
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

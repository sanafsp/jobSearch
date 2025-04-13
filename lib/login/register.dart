// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/const/core/color.dart';
import 'package:job_project/login/forgotpass.dart';
import 'package:job_project/login/signin.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  _RegisterState();

  bool showProgress = false;
  bool visible = false;

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController confirmpassController =
      new TextEditingController();
  final TextEditingController name = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController mobile = new TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  File? file;
  var options = [
    'Company',
    'Workers',
  ];
  var _currentItemSelected = "Workers";
  var rool = "Workers";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.baseColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                   
                    Container(
                      height: 200,
                      width: 500,
                      decoration: BoxDecoration(
                color: Colors.blue, // Background color
                borderRadius: BorderRadius.only(
                  // bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
                      child: Center(
                        child: Text(
                    "Welcome!\nSign up to continue!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: Design.bottom),
                  ),
                      ),
                    ),
                    
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                       color: Design.baseColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
                        child: Column(
                          children: [

                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Design.baseColor,
                                hintText: 'Email',
                                enabled: true,
                                 contentPadding: const EdgeInsets.symmetric(horizontal: 14,vertical: 8),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:  BorderSide(color: Design.baseColor),
                                  borderRadius:  BorderRadius.circular(10),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.white),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                                // enabledBorder: UnderlineInputBorder(
                                //   borderSide: new BorderSide(color: Design.heading),
                                //   borderRadius: new BorderRadius.circular(20),
                                // ),
                              ),
                              validator: (value) {
                                if (value!.length == 0) {
                                  return "Email cannot be empty";
                                }
                                if (!RegExp(
                                        "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                    .hasMatch(value)) {
                                  return ("Please enter a valid email");
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {},
                              keyboardType: TextInputType.emailAddress,
                            ),
                             SizedBox(
                        height: 20,
                                            ),
                                            TextFormField(
                        obscureText: _isObscure,
                        controller: passwordController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(_isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              }),
                          filled: true,
                          fillColor: Design.baseColor,
                          hintText: 'Password',
                          enabled: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14,vertical: 8),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:  BorderSide(color: Design.baseColor),
                                  borderRadius:  BorderRadius.circular(10),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.white),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                        ),
                        validator: (value) {
                          RegExp regex = new RegExp(r'^.{6,}$');
                          if (value!.isEmpty) {
                            return "Password cannot be empty";
                          }
                          if (!regex.hasMatch(value)) {
                            return ("please enter valid password min. 6 character");
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {},
                                            ),
                                            SizedBox(
                        height: 20,
                                            ),
                                            TextFormField(
                        obscureText: _isObscure2,
                        controller: confirmpassController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(_isObscure2
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isObscure2 = !_isObscure2;
                                });
                              }),
                          filled: true,
                          fillColor: Design.baseColor,
                          hintText: 'Confirm Password',
                          enabled: true,
                           contentPadding: const EdgeInsets.symmetric(horizontal: 14,vertical: 8),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:  BorderSide(color: Design.baseColor),
                                  borderRadius:  BorderRadius.circular(10),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.white),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                        ),
                        validator: (value) {
                          if (confirmpassController.text !=
                              passwordController.text) {
                            return "Password did not match";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) {},
                                            ),
                                            SizedBox(
                        height: 20,
                                            ),
                                            Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 10,),
                          Text(
                            "Role : ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                              color: Design.heading,
                            ),
                          ),SizedBox(width: 30,),
                          DropdownButton<String>(
                            dropdownColor: Design.baseColor,
                            isDense: true,
                            isExpanded: false,
                            iconEnabledColor: Design.heading,
                            focusColor:Design.heading,
                            items: options.map((String dropDownStringItem) {
                              return DropdownMenuItem<String>(
                                value: dropDownStringItem,
                                child: Text(
                                  dropDownStringItem,
                                  style: TextStyle(
                                    color: Design.heading,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (newValueSelected) {
                              setState(() {
                                _currentItemSelected = newValueSelected!;
                                rool = newValueSelected;
                              });
                            },
                            value: _currentItemSelected,
                          ),
                        ],
                                            ),
                                            SizedBox(
                        height: 30,
                                            ),
                                             ElevatedButton.icon(
                           onPressed: () {
                              setState(() {
                                showProgress = true;
                              });
                              signUp(emailController.text,
                                  passwordController.text, rool);
                            },
                            
                      label: Text(
                        "Sign Up",
                        style: TextStyle(color: Design.bottom,fontWeight: FontWeight.bold,fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Design.buttonColor,
                        minimumSize: Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                           SizedBox(height: 15),
                            GestureDetector(
                      onTap: () {
                        CircularProgressIndicator();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPasswordScreen(),
                                ),
                              );
                      },
                      child: Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                      SizedBox(height: 10),
                                                GestureDetector(
                      onTap: () {
                        CircularProgressIndicator();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                      },
                      child: Text(
                        "Already have an account? Sign in",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                                            
                          ],
                        ),
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

  void signUp(String email, String password, String rool) async {
    CircularProgressIndicator();
    if (_formkey.currentState!.validate()) {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore(email, rool)})
          .catchError((e) {});
    }
  }

  postDetailsToFirestore(String email, String rool) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({'email': emailController.text, 'rool': rool});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
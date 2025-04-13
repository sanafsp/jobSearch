// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_project/const/core/color.dart';
import 'package:job_project/jobSeeker/joblist.dart';
import 'package:job_project/recruiter/chome.dart';
import 'package:job_project/widget/companyBottom.dart';
import 'package:job_project/widget/workersbottom.dart';
import 'register.dart';



class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.baseColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                   
                     Container(
                      height: 200,
                          decoration: BoxDecoration(
                            color: Colors.blue, // Background color
                            borderRadius: BorderRadius.only(
              // bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
                            ),
                          ),
                          child: Center(child: 
                           Text(
                        "Welcome back!\nSign in to continue!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Design.baseColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                          ),
                      ),
                   
                    SizedBox(
                      height: 50,
                    ),
              
                    Container(
                      // height: 100,
                      // width: 500,
                      color: Design.baseColor,
                      child: Padding(
                         padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Design.bottom,
                                hintText: 'Email',
                                // enabled: true,
                                // contentPadding: const EdgeInsets.only(
                                //     left: 14.0, bottom: 8.0, top: 8.0),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14,vertical: 8),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:  BorderSide(color: Design.baseColor),
                                  borderRadius:  BorderRadius.circular(10),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.white),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                                // enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Design.baseColor),
                                // borderRadius: BorderRadius.circular(10))
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
                              onSaved: (value) {
                                emailController.text = value!;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                             SizedBox(
                        height: 20,
                                            ),
                                            TextFormField(
                        controller: passwordController,
                        obscureText: _isObscure3,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              icon: Icon(_isObscure3
                                  ? Icons.visibility_off
                                  : Icons.visibility ),
                              onPressed: () {
                                setState(() {
                                  _isObscure3 = !_isObscure3;
                                });
                              }),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Password',
                          enabled: true,
                          contentPadding: const EdgeInsets.only(
                              left: 14.0, bottom: 8.0, top: 15.0),
                          focusedBorder: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.white),
                            borderRadius: new BorderRadius.circular(10),
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
                        onSaved: (value) {
                          passwordController.text = value!;
                        },
                        keyboardType: TextInputType.emailAddress,
                                            ),
                                           
                                            SizedBox(
                        height: 30,
                                            ),
                                             ElevatedButton(
                         onPressed: () {
                          setState(() {
                            visible = true;
                          });
                          signIn(
                              emailController.text, passwordController.text);
                        },
                          child: Text("Log in"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                         SizedBox(
                        height: 10,
                                            ),
                                            Visibility(
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          visible: visible,
                          child: Container(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                          ))),
                         GestureDetector(
                                        onTap: () {
                                          Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Register(),
                        ),
                                            );
                                        },
                                        child: Text(
                                          "Create new Account? Sign Up",
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

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('rool') == "Company") {
           Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  Companybottom (),
          ),
        );
        }else{
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>  Workersbottom(),
          ),
        );
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  void signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}



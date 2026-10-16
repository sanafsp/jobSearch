// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_project/Constants/app_styles.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/View/login/forgotpass.dart';
import 'package:job_project/View/login/signin.dart';

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

  final TextEditingController passwordController =  TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController name =  TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobile = TextEditingController();
  bool _isObscure = true;
  bool _isObscure2 = true;
  File? file;
  var options = [
    'Company',
    'Workers',
    'Admin'
  ];
  var _currentItemSelected = "Workers";
  var rool = "Workers";


@override
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;

 SystemUiOverlayStyle(statusBarBrightness: Brightness.dark,statusBarColor: Design.buttonColor,statusBarIconBrightness: Brightness.light);

  return Scaffold(
    backgroundColor: Design.baseColor,
    body: SafeArea(
      child: Column(
        children: [
      
          Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Center(
        child: Text(
          "Welcome !\nSign up to get started",
          textAlign: TextAlign.center,
          style: AppStyles.authGreetingTextStyle,
        ),
      ),
            ),
           
          Expanded(child: SingleChildScrollView(
            child: Column(
              children: [

                 SizedBox(
                    height: .05*size.height,
                  ),
              //  const SizedBox(height: 25),
        
          // REGISTRATION CARD
          
          Card(
            elevation: 10,
            shadowColor: Colors.black38,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
      
                    const Text(
                      "Email",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
        
                    const SizedBox(height: 8),
        
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.blue,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        focusedBorder: AppStyles.textFieldFocusedBorder,
                        enabledBorder: AppStyles.textFieldEnabledBorder,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email cannot be empty";
                        }
        
                        if (!RegExp(
                          r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$",
                        ).hasMatch(value)) {
                          return "Please enter a valid email";
                        }
        
                        return null;
                      },
                    ),
        
                    const SizedBox(height: 20),
        
                    // PASSWORD
                    const Text(
                      "Password",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
        
                    const SizedBox(height: 8),
        
                    TextFormField(
                      controller: passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        hintText: "Enter password",
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: Colors.blue,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        focusedBorder: AppStyles.textFieldFocusedBorder,
                        enabledBorder: AppStyles.textFieldEnabledBorder,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password cannot be empty";
                        }
        
                        if (value.length < 6) {
                          return "Password must contain at least 6 characters";
                        }
        
                        return null;
                      },
                    ),
        
                    const SizedBox(height: 20),
        
                    // CONFIRM PASSWORD
                    const Text(
                      "Confirm Password",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
        
                    const SizedBox(height: 8),
        
                    TextFormField(
                      controller: confirmpassController,
                      obscureText: _isObscure2,
                      decoration: InputDecoration(
                        hintText: "Confirm your password",
                        prefixIcon: const Icon(
                          Icons.lock_reset_outlined,
                          color: Colors.blue,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure2
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure2 = !_isObscure2;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 15,
                        ),
                        focusedBorder: AppStyles.textFieldFocusedBorder,
                        enabledBorder: AppStyles.textFieldEnabledBorder,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm your password";
                        }
        
                        if (value != passwordController.text) {
                          return "Password did not match";
                        }
        
                        return null;
                      },
                    ),
        
                    const SizedBox(height: 25),
        
                    // ROLE
                    const Text(
                      "Register as",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
        
                    const SizedBox(height: 12),
        
                    Row(
                      children: [
                        //  // Admin
                        // Expanded(
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       setState(() {
                        //         rool = "Admin";
                        //         _currentItemSelected = "Admin";
                        //       });
                        //     },
                        //     child: Container(
                        //       padding: const EdgeInsets.symmetric(
                        //         vertical: 15,
                        //       ),
                        //       decoration: BoxDecoration(
                        //         color: rool == "Admin"
                        //             ? Colors.blue
                        //             : Colors.grey.shade100,
                        //         borderRadius: BorderRadius.circular(12),
                        //         border: Border.all(
                        //           color: rool == "Admin"
                        //               ? Colors.blue
                        //               : Colors.grey.shade300,
                        //         ),
                        //       ),
                        //       child: Column(
                        //         children: [
                        //           Icon(
                        //             Icons.person_outline,
                        //             color: rool == "Admin"
                        //                 ? Colors.white
                        //                 : Colors.grey,
                        //             size: 28,
                        //           ),
                        //           const SizedBox(height: 5),
                        //           Text(
                        //             "Admin",
                        //             style: TextStyle(
                        //               color: rool == "Admin"
                        //                   ? Colors.white
                        //                   : Colors.black87,
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
        
                        // const SizedBox(width: 15),
        
                        // WORKER
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                rool = "Workers";
                                _currentItemSelected = "Workers";
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: rool == "Workers"
                                    ? Colors.blue
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: rool == "Workers"
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color: rool == "Workers"
                                        ? Colors.white
                                        : Colors.grey,
                                    size: 28,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Worker",
                                    style: TextStyle(
                                      color: rool == "Workers"
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
        
                        const SizedBox(width: 15),
        
                        // COMPANY
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                rool = "Company";
                                _currentItemSelected = "Company";
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: rool == "Company"
                                    ? Colors.blue
                                    : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: rool == "Company"
                                      ? Colors.blue
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.business_outlined,
                                    color: rool == "Company"
                                        ? Colors.white
                                        : Colors.grey,
                                    size: 28,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Company",
                                    style: TextStyle(
                                      color: rool == "Company"
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
        
                    const SizedBox(height: 30),
        
                    // =========================
                    // SIGN UP BUTTON
                    // =========================
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: showProgress
                            ? null
                            : () {
      
                               if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    showProgress = true;
                                  });
                                  
                             signUp(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                    rool,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white, 
            disabledBackgroundColor:Colors.blue,
          minimumSize: const Size(
            double.infinity,
            50,
          ),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
                        child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
             "Create Account",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              )),
      
              showProgress?SizedBox(width: 10,):SizedBox(),
      
              showProgress?
              SizedBox(
                width: 20,height: 20,
              child: CircularProgressIndicator(color: Colors.white,)):SizedBox()
            ,
          ],
        ),
      
                      ),
                    ),
        
                    const SizedBox(height: 22),
        
                   
                    // LOGIN
                   
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: AppStyles.authQuestionQuoteStyle,
                        ),
        
                        const SizedBox(width: 5),
        
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                            );
                          },
                          child: Text(
                            "Sign In",
                            style:AppStyles.submitBtnTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        
              ],
            ),
          )),
          
          const SizedBox(height: 25),
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
          .catchError((e) {
            
    if (e.code == 'email-already-in-use') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email is already registered. Please login."),
        ),
      );
    } else if (e.code == 'weak-password') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password is too weak."),
        ),
      );
    } else if (e.code == 'invalid-email') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid email address."),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Registration failed")),
      );
    }
          });
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
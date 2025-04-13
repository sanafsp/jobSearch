import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/const/core/color.dart';
import 'package:job_project/login/register.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void resetPassword() async {
    String email = emailController.text.trim();
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset email sent!")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Design.buttonColor,
         leading: IconButton(onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>Register()));
        }, icon: Icon(Icons.arrow_back_ios_new,color: Design.bottom)),
        title: Text("Forgot Password",style: TextStyle(color: Design.bottom),
        ),
        centerTitle: true,
       ),
      body: Padding(
        padding: EdgeInsets.all(35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Design.buttonColor),
              onPressed: resetPassword, child: Text("Reset Password",style: TextStyle(color: Design.bottom),)),
          ],
        ),
      ),
    );
  }
}

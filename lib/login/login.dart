// LOGIN PAGE (login_screen.dart)
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:job_project/login/forgotpass.dart';
import 'package:job_project/jobSeeker/joblist.dart';
import 'package:job_project/login/signup.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => JobListScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.toString()}")),
      );
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: loginUser, child: Text("Login")),
            ElevatedButton(onPressed: signInWithGoogle, child: Text("Login with Google")),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SignupScreen())),
              child: Text("Don't have an account? Sign Up"),
            ),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen())),
              child: Text("Forgot Password?"),
            ),
          ],
        ),
      ),
    );
  }
}
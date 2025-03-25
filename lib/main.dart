// MAIN PAGE (main.dart)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:job_project/admin/admindashb.dart';
import 'package:job_project/login/signin.dart';
import 'package:job_project/recruiter/posting.dart';
import 'package:job_project/home/resume.dart';
import 'package:job_project/jobSeeker/dashbord.dart';
import 'package:job_project/jobSeeker/profile.dart';
import 'package:job_project/jobSeeker/saveJob.dart';
import 'package:job_project/login/login.dart';
import 'package:job_project/recruiter/profileScreen.dart';
import 'package:job_project/login/register.dart';
import 'package:job_project/recruiter/application.dart';
import 'package:share_plus/share_plus.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginScreen(), 
      // home: AdminDashboard(),
      home: LoginPage  (),
      // home: AdminJobApplicationsScreen ()
      // JobApplicationScreen(
      //         jobId: jobId,  //  Pass the correct jobId
      //         userId: userId,  // Correct User ID
    // ),



    );
  }
}

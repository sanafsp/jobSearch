import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/jobSeeker/apply.dart';
import 'package:job_project/jobSeeker/profile.dart';
import 'package:job_project/jobSeeker/saveJob.dart';

class JobSeekerDashboard extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void logout(BuildContext context) {
    _auth.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Seeker Dashboard"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          )
        ],
      ),
      body: Column(
        children: [
          ListTile(
            title: Text("My Profile"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => JobSeekerProfileScreen(userId: FirebaseAuth.instance.currentUser!.uid),)),
          ),
          ListTile(
            title: Text("Applied Jobs"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AppliedJobsScreen())),
          ),
          ListTile(
            title: Text("Saved Jobs"),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SavedJobsScreen())),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_project/const/core/color.dart';
import 'package:job_project/recruiter/application.dart';
import 'package:job_project/widget/workersbottom.dart';

class JobApplicationScreen extends StatefulWidget {
  final String jobId;
  final String recruiterId; 

  JobApplicationScreen({required this.jobId, required this.recruiterId});

  @override
  _JobApplicationScreenState createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {
  String _applicationStatus = "Not Applied"; 
  String _jobTitle = "Loading..."; 
  String _userEmail = ""; 
  String _userId = "";

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _fetchJobDetails();
    _fetchApplicationStatus();
  }

 
  void _initializeUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
        _userEmail = user.email ?? "No Email Available";
      });
    }
  }

  // Fetch Job Title
  Future<void> _fetchJobDetails() async {
    DocumentSnapshot jobSnapshot =
        await FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).get();

    if (jobSnapshot.exists) {
      setState(() {
        _jobTitle = jobSnapshot['title'] ?? "Unknown Job"; 
      });
    }
  }

  //  Fetch Job Application Status
  Future<void> _fetchApplicationStatus() async {
    if (_userId.isEmpty) return; 

    DocumentSnapshot application = await FirebaseFirestore.instance
        .collection('job_applications')
        .doc("${_userId}_${widget.jobId}")
        .get();

    if (application.exists) {
      setState(() {
        _applicationStatus = application['status'];
      });
    }
  }

  //  Apply for Job & Move Request to Recruiter
  Future<void> _applyForJob() async {
    await FirebaseFirestore.instance
        .collection('job_applications')
        .doc("${_userId}_${widget.jobId}")
        .set({
      'userId': _userId,
      'jobId': widget.jobId,
      'recruiterId': widget.recruiterId,
      'userEmail': _userEmail, 
      'jobTitle': _jobTitle, 
      'status': "Applied",
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      _applicationStatus = "Applied";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(" Job Application Submitted!")),
    );

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.baseColor,
      appBar: AppBar(
        backgroundColor: Design.buttonColor,
        title: Text("Job Application Status",style: TextStyle(color: Design.bottom ),),
         leading: IconButton(onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>Workersbottom()));
        }, icon: Icon(Icons.arrow_back_ios_new,color: Design.bottom)),),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 150,),
            Center(
              child: Text(" $_jobTitle",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(width: 20,),
                Text("Application Status:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
                    Text(" $_applicationStatus",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 20),
            

            if (_applicationStatus == "Not Applied") 
              Center(
                child: ElevatedButton(
                  style:ElevatedButton.styleFrom(backgroundColor: Design.buttonColor),
                  onPressed: _applyForJob,
                  child: Text("Apply for Job", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Design.bottom)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

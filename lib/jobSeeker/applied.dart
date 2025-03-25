import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_project/recruiter/application.dart';

class JobApplicationScreen extends StatefulWidget {
  final String jobId;
  final String recruiterId; // Recruiter's unique ID

  JobApplicationScreen({required this.jobId, required this.recruiterId});

  @override
  _JobApplicationScreenState createState() => _JobApplicationScreenState();
}

class _JobApplicationScreenState extends State<JobApplicationScreen> {
  String _applicationStatus = "Not Applied"; // Default status
  String _jobTitle = "Loading..."; // Default job title
  String _userEmail = ""; // User email for display
  String _userId = ""; // User ID

  @override
  void initState() {
    super.initState();
    _initializeUser();
    _fetchJobDetails();
    _fetchApplicationStatus();
  }

  // 🔹 Initialize User ID & Email
  void _initializeUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
        _userEmail = user.email ?? "No Email Available";
      });
    }
  }

  // 🔹 Fetch Job Title
  Future<void> _fetchJobDetails() async {
    DocumentSnapshot jobSnapshot =
        await FirebaseFirestore.instance.collection('jobs').doc(widget.jobId).get();

    if (jobSnapshot.exists) {
      setState(() {
        _jobTitle = jobSnapshot['title'] ?? "Unknown Job"; // Get job title
      });
    }
  }

  // 🔹 Fetch Job Application Status
  Future<void> _fetchApplicationStatus() async {
    if (_userId.isEmpty) return; // Ensure _userId is set before querying

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

  // 🔹 Apply for Job & Move Request to Recruiter
  Future<void> _applyForJob() async {
    await FirebaseFirestore.instance
        .collection('job_applications')
        .doc("${_userId}_${widget.jobId}")
        .set({
      'userId': _userId,
      'jobId': widget.jobId,
      'recruiterId': widget.recruiterId, // Save Recruiter ID
      'userEmail': _userEmail, // Save user email
      'jobTitle': _jobTitle, // Save job title
      'status': "Applied",
      'timestamp': FieldValue.serverTimestamp(),
    });

    setState(() {
      _applicationStatus = "Applied";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Job Application Submitted!")),
    );

    // ✅ Navigate to Recruiter's Applications Page (Automatically)
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => RecruiterJobApplicationsScreen(recruiterId: widget.recruiterId),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Job Application Status")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Job Title: $_jobTitle",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Application Status: $_applicationStatus",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),

            if (_applicationStatus == "Not Applied") // Show Apply button
              ElevatedButton(
                onPressed: _applyForJob,
                child: Text("Apply for Job"),
              ),
          ],
        ),
      ),
    );
  }
}

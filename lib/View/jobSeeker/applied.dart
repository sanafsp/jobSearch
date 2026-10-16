// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/View/recruiter/application.dart';
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
    elevation: 0,

    leading: IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Workersbottom(),
          ),
        );
      },
      icon: Icon(
        Icons.arrow_back_ios_new,
        color: Design.bottom,
      ),
    ),

    title: Text(
      "Application Status",
      style: TextStyle(
        color: Design.bottom,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),

  body: SingleChildScrollView(
    padding: const EdgeInsets.all(20),

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 20),

        // TITLE 

        Text(
          "Your Application",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          _jobTitle,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 25),

        //status

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),

          child: Column(
            children: [

             
              Container(
                width: 75,
                height: 75,

                decoration: BoxDecoration(
                  color: _getStatusColor(
                    _applicationStatus,
                  ).withOpacity(0.12),

                  shape: BoxShape.circle,
                ),

                child: Icon(
                  _getStatusIcon(
                    _applicationStatus,
                  ),

                  size: 40,

                  color: _getStatusColor(
                    _applicationStatus,
                  ),
                ),
              ),

              const SizedBox(height: 18),

             
              Text(
                _getStatusTitle(
                  _applicationStatus,
                ),

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

             
              Text(
                _getStatusMessage(
                  _applicationStatus,
                ),

                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 20),

              
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 9,
                ),

                decoration: BoxDecoration(
                  color: _getStatusColor(
                    _applicationStatus,
                  ).withOpacity(0.12),

                  borderRadius: BorderRadius.circular(30),
                ),

                child: Text(
                  _applicationStatus,

                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(
                      _applicationStatus,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

       

        const Text(
          "Application Details",
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          width: double.infinity,

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),

            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),

          child: Row(
            children: [

              Container(
                width: 45,
                height: 45,

                decoration: BoxDecoration(
                  color: Design.buttonColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(12),
                ),

                child: Icon(
                  Icons.work_outline,
                  color: Design.buttonColor,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      "Job Position",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _jobTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        // apply

        if (_applicationStatus == "Not Applied")

          SizedBox(
            width: double.infinity,
            height: 52,

            child: ElevatedButton(
              onPressed: (){
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    title: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        
                        Text("Apply for Jpob",style: TextStyle(fontWeight: FontWeight.bold),)
                      ],
                    ),
                    content: Text("Are you ready to apply for this job?\n\n", style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                ),),
                actions: [
                  TextButton(onPressed: (){
                    Navigator.pop(context);
                  }, child:const Text(
                    "Cancel",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),) ),
                    ElevatedButton(onPressed: (){
                       Navigator.pop(context);

                    _applyForJob();
                    },
                    style: ElevatedButton.styleFrom(
                    backgroundColor: Design.buttonColor,
                    foregroundColor: Design.bottom,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                    
                     child: Text(
                    "Apply Now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ), )
                    
                ],
                  );
                });
                
              },


              // onPressed: _applyForJob,

              style: ElevatedButton.styleFrom(
                backgroundColor: Design.buttonColor,
                foregroundColor: Design.bottom,

                elevation: 2,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              child: const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  Icon(
                    Icons.send_rounded,
                    size: 20,
                  ),

                  SizedBox(width: 8),

                  Text(
                    "Apply for Job",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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


  Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case "applied":
      return Colors.blue;

    case "interview":
      return Colors.orange;

    case "hired":
      return Colors.green;

    case "rejected":
      return Colors.red;

    case "not applied":
      return Colors.grey;

    default:
      return Colors.grey;
  }
}

IconData _getStatusIcon(String status) {
  switch (status.toLowerCase()) {
    case "applied":
      return Icons.check_circle_outline;

    case "interview":
      return Icons.event_available_outlined;

    case "hired":
      return Icons.verified_outlined;

    case "rejected":
      return Icons.cancel_outlined;

    case "not applied":
      return Icons.description_outlined;

    default:
      return Icons.info_outline;
  }
}

String _getStatusTitle(String status) {
  switch (status.toLowerCase()) {
    case "applied":
      return "Application Submitted";

    case "interview":
      return "Interview Scheduled";

    case "hired":
      return "Congratulations!";

    case "rejected":
      return "Application Not Selected";

    case "not applied":
      return "Ready to Apply";

    default:
      return "Application Status";
  }
}

String _getStatusMessage(String status) {
  switch (status.toLowerCase()) {
    case "applied":
      return "Your application has been submitted successfully. The recruiter will review your application.";

    case "interview":
      return "Great! The recruiter has selected you for an interview. Please check your interview details.";

    case "hired":
      return "Congratulations! You have been selected for this position.";

    case "rejected":
      return "Unfortunately, your application was not selected for this position. Keep applying for other opportunities.";

    case "not applied":
      return "You have not applied for this job yet. Apply now to start your application.";

    default:
      return "Check your application status for more information.";
  }
}


}

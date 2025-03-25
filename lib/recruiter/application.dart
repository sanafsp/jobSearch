import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecruiterJobApplicationsScreen extends StatelessWidget {
  final String recruiterId;

  RecruiterJobApplicationsScreen({required this.recruiterId});

  // 🔹 Update Job Application Status
  Future<void> _updateApplicationStatus(String docId, String newStatus) async {
    await FirebaseFirestore.instance.collection('job_applications').doc(docId).update({'status': newStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Job Applications")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('job_applications')
            .where('recruiterId', isEqualTo: recruiterId) // ✅ Show only recruiter's applications
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var applications = snapshot.data!.docs;
          if (applications.isEmpty) {
            return Center(child: Text("No applications for your jobs."));
          }

          return ListView.builder(
            itemCount: applications.length,
            itemBuilder: (context, index) {
              var appData = applications[index];
              String docId = appData.id;

              // ✅ Ensure 'jobTitle', 'userEmail', and 'status' exist
              String jobTitle = appData['jobTitle'] ?? "Unknown Job";
              String userEmail = appData['userEmail'] ?? "Unknown Email";
              String status = appData['status'] ?? "Pending";

              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text("Job: $jobTitle"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Applicant: $userEmail"),
                      Text("Status: $status", style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) => _updateApplicationStatus(docId, value),
                    itemBuilder: (context) => [
                      PopupMenuItem(value: "Interview", child: Text("Move to Interview")),
                      PopupMenuItem(value: "Rejected", child: Text("Reject")),
                      PopupMenuItem(value: "Hired", child: Text("Hire")),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

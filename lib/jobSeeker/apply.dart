// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/const/core/color.dart';

class AppliedJobsScreen extends StatefulWidget {
  @override
  _AppliedJobsScreenState createState() => _AppliedJobsScreenState();
}

class _AppliedJobsScreenState extends State<AppliedJobsScreen> with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TabController? _tabController;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.baseColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Design.buttonColor,
        title: Center(child: Text("Applied Jobs", style: TextStyle(color: Design.bottom))),
        bottom: TabBar(
          labelColor: Design.bottom,
          controller: _tabController,
          tabs: [
            Tab(text: "Applied"),
            Tab(text: "Hired"),
            Tab(text: "Interview"),
            Tab(text: "Rejected"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildJobList("Applied"),
          _buildJobList("Hired"),
          _buildJobList("Interview"),
          _buildJobList("Rejected"),
        ],
      ),
    );
  }

  Widget _buildJobList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('job_applications')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error loading data"));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No jobs in $status"));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var job = snapshot.data!.docs[index];
            Map<String, dynamic> jobData = job.data() as Map<String, dynamic>;
            String jobTitle = jobData.containsKey('jobTitle') ? jobData['jobTitle'] : "No Title";
            String jobId = jobData.containsKey('jobId') ? jobData['jobId'] : "";
            String jobStatus = jobData.containsKey('status') ? jobData['status'] : "Unknown";

            // Handle case where jobId is missing or empty
            if (jobId.isEmpty) {
              return Card(
                color: Design.bottom,
                elevation: 10,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(jobTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(" Job ID not available"),
                  trailing: Text(
                    jobStatus,
                    style: TextStyle(
                      color: _getStatusColor(jobStatus),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }

            return FutureBuilder<DocumentSnapshot>(
              future: _firestore.collection('jobs').doc(jobId).get(),
              builder: (context, jobSnapshot) {
                String companyName = "Loading...";

                if (jobSnapshot.connectionState == ConnectionState.done) {
                  if (jobSnapshot.hasData && jobSnapshot.data!.exists) {
                    Map<String, dynamic> jobDetails = jobSnapshot.data!.data() as Map<String, dynamic>;
                    if (jobDetails.containsKey('companyName')) {
                      companyName = jobDetails['companyName'];
                    } else if (jobDetails.containsKey('company')) {
                      companyName = jobDetails['company'];
                    } else {
                      companyName = "No Company Name Found";
                      print(" Firestore Warning: companyName field missing in jobId: $jobId");
                    }
                  } else {
                    companyName = "Job Not Found";
                    print(" Firestore Warning: Job document missing for jobId: $jobId");
                  }
                }

                return Card(
                  color: Design.bottom,
                  elevation: 10,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    title: Text(jobTitle, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("🏢 Company: $companyName"),
                    trailing: Text(
                      jobStatus,
                      style: TextStyle(
                        color: _getStatusColor(jobStatus),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Hired":
        return Colors.green;
      case "Interview":
        return Colors.orange;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

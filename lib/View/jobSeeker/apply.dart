// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors,
// prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/Constants/core/color.dart';

class AppliedJobsScreen extends StatefulWidget {
  @override
  _AppliedJobsScreenState createState() => _AppliedJobsScreenState();
}

class _AppliedJobsScreenState extends State<AppliedJobsScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

  late final TabController _tabController = TabController(length: 4, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
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
          unselectedLabelColor: Colors.white70,
          indicatorColor: Design.bottom,
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

  /* ───────────────────────── LIST BUILDER ───────────────────────── */

  Widget _buildJobList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('job_applications')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: status)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Design.buttonColor,));
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading data", style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No jobs in $status",
                style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),));
        }
         final documents = snapshot.data!.docs;


        // return ListView.builder(
        //   itemCount: snapshot.data!.docs.length,
          return ListView.separated(
          padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemCount: documents.length,


          itemBuilder: (context, index) {
            var job = snapshot.data!.docs[index];
            Map<String, dynamic> jobData = job.data() as Map<String, dynamic>;

            final jobTitle = jobData['jobTitle'] ?? "No Title";
            final jobId    = jobData['jobId']    ?? "";
            final jobStatus= jobData['status']   ?? "Unknown";

            final interviewDate = jobData['interviewDate'];      
            final interviewTime = jobData['interviewTime'];      
            final interviewDT   = jobData['interviewDateTime'];  //  optional combined field

            if (jobId.isEmpty) {
              return _statusCard(
                title: jobTitle,
                company: "Job ID not available",
                status: jobStatus,
                extra: _interviewText(status, interviewDate, interviewTime, interviewDT),
              );
            }

            // Fetch the job's company name
            return FutureBuilder<DocumentSnapshot>(
              future: _firestore.collection('jobs').doc(jobId).get(),
              builder: (context, snap) {
                String companyName = "Loading...";
                if (snap.connectionState == ConnectionState.done && snap.data?.exists == true) {
                  final details = snap.data!.data() as Map<String, dynamic>;
                  companyName = details['companyName'] ??
                                details['company'] ??
                                "No Company Name Found";
                } else if (snap.connectionState == ConnectionState.done) {
                  companyName = "Job Not Found";
                }

                return _statusCard(
                  title: jobTitle,
                  company: "🏢 Company: $companyName",
                  status: jobStatus,
                  extra: _interviewText(status, interviewDate, interviewTime, interviewDT),
                );
              },
            );
          },
        );
      },
    );
  }



  // Re-usable card widget
  Widget _statusCard({
    required String title,
    required String company,
    required String status,
    Widget? extra,
  }) {
    return Card(
      color: Design.bottom,
      elevation: 10,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(company),
            if (extra != null) extra, // interview info if provided
          ],
        ),
        trailing: Text(
          status,
          style: TextStyle(
            color: _getStatusColor(status),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  //  Build interview text only for Interview tab
  Widget? _interviewText(
    String status,
    dynamic date,
    dynamic time,
    dynamic combined,
  ) {
    if (status != "Interview") return null;

    String info;
    if (combined != null) {
      info = "Interview: $combined";
    } else if (date != null && time != null) {
      info = "Interview: $date at $time";
    } else if (date != null) {
      info = "Interview Date: $date";
    } else {
      info = "Interview date not set";
    }

    return Padding(
      padding: EdgeInsets.only(top: 4),
      child: Text(
        info,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.orangeAccent),
      ),
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

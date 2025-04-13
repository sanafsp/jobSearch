// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/const/core/color.dart';

class CompanyJobsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser; 

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Your Jobs")),
        body: Center(child: Text("Please log in to view your jobs.")),
      );
    }

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('recruiterId', isEqualTo: user.uid) 
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No jobs posted yet."));
          }

          var jobs = snapshot.data!.docs;

          return Column(
            children: [
              Container(
                height: 200,
                width: double.infinity, 
                decoration: BoxDecoration(
                  color: Design.buttonColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Center(
                  child: Text(
                    jobs.isNotEmpty ? "🏢 ${jobs[0]['company']}" : "Your Posted Jobs", 
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Design.bottom),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    var job = jobs[index].data() as Map<String, dynamic>; 
                    String jobId = jobs[index].id; 

                    return Card(
                      color: Design.bottom,
                      elevation: 10,
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(job['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("🏢  ${job['company']}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text("📍  ${job['location']}", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15)),
                            Text("💰  ${job['salary']}", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15)),
                            Text("Experience: ${job['experience']} years", style: TextStyle(fontWeight: FontWeight.normal, fontSize: 15)),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => showDeleteDialog(context, jobId),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Function to show delete confirmation dialog
  void showDeleteDialog(BuildContext context, String jobId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Job"),
        content: Text("Are you sure you want to delete this job? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              deleteJob(jobId, context); 
              Navigator.pop(context); 
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Function to delete a job from Firestore
  void deleteJob(String jobId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('jobs').doc(jobId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Job deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting job: $e")),
      );
    }
  }
}

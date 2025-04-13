// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_project/const/core/color.dart';
import 'package:job_project/jobSeeker/jobdetails.dart';

class SavedJobsScreen extends StatefulWidget {
  @override
  _SavedJobsScreenState createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends State<SavedJobsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _savedJobs = [];

  @override
  void initState() {
    super.initState();
    _loadSavedJobs();
  }

  Future<void> _loadSavedJobs() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    if (userId.isEmpty) return;

    QuerySnapshot snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_jobs')
        .get();

    setState(() {
      _savedJobs = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Assign Firestore document ID
        return data;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.baseColor,
      body: Column(
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
                "Job Listings",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25, fontWeight: FontWeight.bold, color: Design.bottom),
              ),
            ),
          ),
          Expanded(
            child: _savedJobs.isEmpty
                ? Center(child: Text("No saved jobs yet!"))
                : ListView.builder(
                    itemCount: _savedJobs.length,
                    itemBuilder: (context, index) {
                      var job = _savedJobs[index];
                      String jobId = job['id'] ?? ''; // Ensure 'id' exists

                      return GestureDetector(
                        onTap: () {
                          print("Navigating to JobDetailScreen with jobId: $jobId"); // Debugging
                          if (jobId.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JobDetailScreen(jobId: jobId),
                              ),
                            );
                          } else {
                            print("Error: jobId is empty!");
                          }
                        },
                        child: Card(
                          color: Design.bottom,
                          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job['title'] ?? "Unknown Job",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text('🏢  '),
                                    Text(
                                      job['company'] ?? "Unknown Company",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey[700]),
                                    ),
                                    SizedBox(width: 10),
                                    Text('📍 '),
                                    Text(
                                      job['location'] ?? "Unknown Location",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      _savedJobs = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Saved Jobs")),
      body: _savedJobs.isEmpty
          ? Center(child: Text("No saved jobs yet!"))
          : ListView.builder(
              itemCount: _savedJobs.length,
              itemBuilder: (context, index) {
                var job = _savedJobs[index];
                return Card(
                  child: ListTile(
                    title: Text(job['title']),
                    subtitle: Text(job['company']),
                  ),
                );
              },
            ),
    );
  }
}

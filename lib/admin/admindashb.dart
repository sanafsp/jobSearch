import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void approveJob(String jobId) {
    _firestore.collection('jobs').doc(jobId).update({'isApproved': true});
  }

  void rejectJob(String jobId) {
    _firestore.collection('jobs').doc(jobId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard")),
      body: StreamBuilder(
        stream: _firestore.collection('jobs').where('isApproved', isEqualTo: false).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No pending job approvals"));
          }
          return ListView(
            children: snapshot.data!.docs.map((job) {
              return ListTile(
                title: Text(job['title']),
                subtitle: Text(job['company']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => approveJob(job.id),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => rejectJob(job.id),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

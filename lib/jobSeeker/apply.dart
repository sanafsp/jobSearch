import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppliedJobsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Applied Jobs")),
      body: StreamBuilder(
        stream: _firestore.collection('applications').where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No applications yet"));
          }
          return ListView(
            children: snapshot.data!.docs.map((job) {
              return ListTile(
                title: Text(job['jobTitle']),
                subtitle: Text(job['status']),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

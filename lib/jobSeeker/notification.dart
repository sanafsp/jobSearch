import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_project/const/core/color.dart';
import 'package:job_project/jobSeeker/jobdetails.dart';
import 'package:job_project/widget/workersbottom.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
  Set<String> viewedJobIds = {};

  @override
  void initState() {
    super.initState();
    _loadViewedJobs();
  }

  Future<void> _loadViewedJobs() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('viewed_notifications')
        .get();

    setState(() {
      viewedJobIds = snapshot.docs.map((doc) => doc.id).toSet();
    });
  }

  Future<void> _markJobAsViewed(String jobId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('viewed_notifications')
        .doc(jobId)
        .set({'viewed': true});

    setState(() {
      viewedJobIds.add(jobId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Timestamp cutoff = Timestamp.fromDate(DateTime.now().subtract(Duration(days: 2)));

    return Scaffold(
      appBar: AppBar(
         backgroundColor: Design.buttonColor,
         leading: IconButton(onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>Workersbottom()));
        }, icon: Icon(Icons.arrow_back_ios_new,color: Design.bottom)),
        title: Text("Notifications",style: TextStyle(color: Design.bottom),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('postedAt', isGreaterThan: cutoff)
            .orderBy('postedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));

          final jobs = snapshot.data?.docs ?? [];

          // Filter jobs not yet viewed
          final newJobs = jobs.where((job) => !viewedJobIds.contains(job.id)).toList();

          if (newJobs.isEmpty) return Center(child: Text("No new job notifications"));

          return ListView.builder(
            itemCount: newJobs.length,
            itemBuilder: (context, index) {
              var job = newJobs[index];
              var data = job.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(data['title'] ?? 'No Title'),
                subtitle: Text("${data['company'] ?? ''} • ${data['location'] ?? ''}"),
                trailing: Icon(Icons.notifications, color: Colors.red),
                onTap: () async {
                  await _markJobAsViewed(job.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => JobDetailScreen(jobId: job.id)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

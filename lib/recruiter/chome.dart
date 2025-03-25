import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompanyJobsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser; // Get recruiter
    
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Your Jobs")),
        body: Center(child: Text("Please log in to view your jobs.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Your Posted Jobs")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('recruiterId', isEqualTo: user.uid) // ✅ Fetch only recruiter's jobs
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No jobs posted yet."));
          }

          var jobs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              var job = jobs[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(job['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Company: ${job['company']}"),
                      Text("Location: ${job['location']}"),
                      Text("Salary: ${job['salary']}"),
                      Text("Experience: ${job['experience']} years"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteJob(job.id, context), // ✅ Delete job
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void deleteJob(String jobId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('jobs').doc(jobId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Job deleted successfully!"))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting job: $e"))
      );
    }
  }
}

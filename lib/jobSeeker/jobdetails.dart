import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:job_project/jobSeeker/applied.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensure plugins are registered
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Job Details',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: JobDetailScreen(jobId: "sampleJobId123"), // Replace with dynamic jobId
//     );
//   }
// }

class JobDetailScreen extends StatelessWidget {
  final String jobId;

  JobDetailScreen({required this.jobId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('jobs').doc(jobId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(body: Center(child: Text(" Job not found!")));
        }

        // ✅ Fetch job details correctly
        Map<String, dynamic> jobData = snapshot.data!.data() as Map<String, dynamic>;
        String recruiterId = jobData['recruiterId'] ?? ""; // Fetch recruiterId from Firestore

        return JobDetailContent(jobData: jobData, jobId: jobId, recruiterId: recruiterId);
      },
    );
  }
}

class JobDetailContent extends StatelessWidget {
  final Map<String, dynamic> jobData;
  final String jobId;
  final String recruiterId;

  JobDetailContent({required this.jobData, required this.jobId, required this.recruiterId});

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "Guest"; // ✅ Get User ID

    return Scaffold(
      appBar: AppBar(
        title: Text(jobData['title'] ?? "Job Details"),
        actions: [
          IconButton(
            icon: Icon(Icons.share), // ✅ Share button
            onPressed: () => _shareJob(context),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(jobData['title'] ?? "No Title", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("🏢 Company: ${jobData['company'] ?? 'Unknown'}", style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text("📍 Location: ${jobData['location'] ?? 'Not mentioned'}"),
            SizedBox(height: 8),
            Text("💰 Salary: ${jobData['salary'] != null ? '\$${jobData['salary']}' : 'N/A'}"),
            SizedBox(height: 8),
            Text("📅 Experience: ${jobData['experience'] ?? 'Not mentioned'}"),
            SizedBox(height: 16),
            Text("📜 Job Description:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(jobData['description'] ?? "No description provided.", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (userId != "Guest") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobApplicationScreen(
                          jobId: jobId,
                          recruiterId: recruiterId,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("⚠ Error: Invalid user ID")),
                    );
                  }
                },
                child: Text("Apply Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Share job details with better error handling
  void _shareJob(BuildContext context) async {
    try {
      String jobTitle = jobData['title'] ?? "Job Opportunity";
      String company = jobData['company'] ?? "Unknown Company";
      String location = jobData['location'] ?? "Not mentioned";
      String salary = jobData['salary'] != null ? '\$${jobData['salary']}' : 'N/A';
      String description = jobData['description'] ?? "No description available.";

      String shareText = """
📢 Job Opportunity: $jobTitle
🏢 Company: $company
📍 Location: $location
💰 Salary: $salary
📝 Description: $description

Apply now on our job portal! 🚀
""";

      await Share.share(shareText); // ✅ Correct function call
  } catch (e) {
    print("❌ Error sharing job: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Error sharing job. Please try again.")),
    );
  }
}
}

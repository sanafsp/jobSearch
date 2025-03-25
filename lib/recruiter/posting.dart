import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/recruiter/chome.dart';

class PostJobScreen extends StatefulWidget {
  @override
  _PostJobScreenState createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void postJob(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You must be logged in to post a job!"))
      );
      return;
    }

    String title = titleController.text.trim();
    String company = companyController.text.trim();
    String salary = salaryController.text.trim();
    String location = locationController.text.trim();
    String description = descriptionController.text.trim();
    String experience = experienceController.text.trim();

    if (title.isEmpty || company.isEmpty || salary.isEmpty || location.isEmpty || description.isEmpty || experience.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields!"))
      );
      return;
    }

    try {
      await _firestore.collection('jobs').add({
        'title': title,
        'company': company,
        'salary': salary,
        'location': location,
        'description': description,
        'experience': experience,
        'postedAt': FieldValue.serverTimestamp(),
        'recruiterId': user.uid, // ✅ Stores the recruiter's ID
      });

      // Clear fields
      titleController.clear();
      companyController.clear();
      salaryController.clear();
      locationController.clear();
      descriptionController.clear();
      experienceController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Job Posted Successfully!"))
      );

      // Navigate to CompanyJobsScreen (view posted jobs)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CompanyJobsScreen()),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error posting job: $e"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Post a Job")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Job Title")),
            TextField(controller: companyController, decoration: InputDecoration(labelText: "Company Name")),
            TextField(controller: salaryController, decoration: InputDecoration(labelText: "Salary")),
            TextField(controller: locationController, decoration: InputDecoration(labelText: "Job Location")),
            TextField(controller: descriptionController, decoration: InputDecoration(labelText: "Job Description"), maxLines: 4),
            TextField(controller: experienceController, decoration: InputDecoration(labelText: "Experience Required")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => postJob(context),
              child: Text("Post Job"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobSeekerProfileScreen extends StatefulWidget {
  final String userId; // Required user ID

  JobSeekerProfileScreen({required this.userId});

  @override
  _JobSeekerProfileScreenState createState() => _JobSeekerProfileScreenState();
}

class _JobSeekerProfileScreenState extends State<JobSeekerProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _resumeController = TextEditingController(); // Resume as text

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  // 🔹 Fetch user profile data with error handling
  Future<void> _fetchProfileData() async {
    setState(() => _isLoading = true);

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('job_seekers')
        .doc(widget.userId)
        .get();

    if (userDoc.exists && userDoc.data() != null) {
      var data = userDoc.data() as Map<String, dynamic>; // Convert to Map

      setState(() {
        _nameController.text = data['name'] ?? ""; // Check if key exists
        _experienceController.text = data['experience'] ?? "";
        _skillsController.text = data['skills'] ?? "";
        _resumeController.text = data['resume'] ?? ""; // Handle missing field safely
      });
    }

    setState(() => _isLoading = false);
  }

  // 🔹 Save or Update Profile Data
  Future<void> _saveProfileData() async {
    setState(() => _isLoading = true);

    await FirebaseFirestore.instance.collection('job_seekers').doc(widget.userId).set({
      'name': _nameController.text.trim(),
      'experience': _experienceController.text.trim(),
      'skills': _skillsController.text.trim(),
      'resume': _resumeController.text.trim(), // Save resume as text
    }, SetOptions(merge: true)); // 🔥 Merge to avoid overwriting missing fields

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ Profile Updated Successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Job Seeker Profile")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: "Full Name"),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _experienceController,
                      decoration: InputDecoration(labelText: "Experience (Years)"),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _skillsController,
                      decoration: InputDecoration(labelText: "Skills (Comma separated)"),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _resumeController,
                      maxLines: 4,
                      decoration: InputDecoration(labelText: "Resume (Text format)"),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveProfileData,
                      child: Text("Save Profile"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

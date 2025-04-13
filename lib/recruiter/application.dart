// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:job_project/const/core/color.dart';

class RecruiterJobApplicationsScreen extends StatefulWidget {
  final String recruiterId;

  RecruiterJobApplicationsScreen({required this.recruiterId});

  @override
  _RecruiterJobApplicationsScreenState createState() => _RecruiterJobApplicationsScreenState();
}

class _RecruiterJobApplicationsScreenState extends State<RecruiterJobApplicationsScreen> {
  Map<String, dynamic>? selectedJobSeeker;
  String? selectedUserId;

  //  Fetch job seeker's details 
  Future<void> _fetchJobSeekerDetails(String userId) async {
    if (selectedUserId == userId) {
      setState(() {
        selectedUserId = null;
        selectedJobSeeker = null;
      });
      return;
    }

    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('job_seekers').doc(userId).get();

    if (userDoc.exists) {
      setState(() {
        selectedUserId = userId;
        selectedJobSeeker = userDoc.data() as Map<String, dynamic>;
      });
    }
  }

  // Update Job Application Status
  Future<void> _updateApplicationStatus(String docId, String newStatus) async {
    if (newStatus == "Interview") {
      _showInterviewDialog(docId);
    } else {
      await FirebaseFirestore.instance.collection('job_applications').doc(docId).update({'status': newStatus});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Application status updated to $newStatus")),
      );
    }
  }

  // Show dialog to select interview date & time
  void _showInterviewDialog(String docId) {
    TextEditingController dateController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Schedule Interview"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: "Select Date",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                      dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                    });
                  }
                },
              ),
              TextField(
                controller: timeController,
                decoration: InputDecoration(
                  labelText: "Select Time",
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      selectedTime = pickedTime;
                      timeController.text = pickedTime.format(context);
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedDate != null && selectedTime != null) {
                  String interviewDateTime = "${dateController.text} at ${timeController.text}";

                  await FirebaseFirestore.instance.collection('job_applications').doc(docId).update({
                    'status': 'Interview',
                    'interviewDateTime': interviewDateTime,
                  });

                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Interview scheduled on $interviewDateTime")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select both date and time.")),
                  );
                }
              },
              child: Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.baseColor,
     

      body:
       StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('job_applications')
            .where('recruiterId', isEqualTo: widget.recruiterId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          var applications = snapshot.data!.docs;
          if (applications.isEmpty) 
          return Center(child: Text("No applications for your jobs."));

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
                 "My Job Applications",
                 
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Design.bottom),
                ),
              ),
            ),
              Expanded(
                child: ListView.builder(
                  itemCount: applications.length,
                  itemBuilder: (context, index) {
                    var appData = applications[index];
                    String docId = appData.id;
                
                    String jobTitle = appData['jobTitle'] ?? "Unknown Job";
                    String userEmail = appData['userEmail'] ?? "Unknown Email";
                    String status = appData['status'] ?? "Pending";
                    String userId = appData['userId'] ?? ""; 
                
                    return Card(
                      color: Design.bottom,
                      elevation: 10,
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(" $jobTitle",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Applicant: $userEmail",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 15)),
                                Text("Status: $status", style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                           trailing: Row(
    mainAxisSize: MainAxisSize.min, // Important to avoid layout issues
    children: [
      IconButton(
        icon: Icon(Icons.edit, color: Colors.blue),
        onPressed: () {
          // Edit action
        },
      ),
      IconButton(
        icon: Icon(Icons.delete, color: Colors.red),
        onPressed: () {
          // Delete action
        },
      ),
    ],
  ),),
                
                          if (selectedUserId == userId && selectedJobSeeker != null)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildProfileField("Name", selectedJobSeeker!['name']),
                                  _buildProfileField("Address", selectedJobSeeker!['address']),
                                  _buildProfileField("Email", selectedJobSeeker!['email']),
                                  _buildProfileField("Skills", selectedJobSeeker!['skills']),
                                  _buildProfileField("Education", selectedJobSeeker!['education']),
                                  _buildExperienceSection(selectedJobSeeker!['experience']),
                                ],
                              ),
                            ),
                        ],
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

  Widget _buildProfileField(String label, String? value) {
    return value != null
        ? Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text("$label: $value", style: TextStyle(fontSize: 14)),
          )
        : SizedBox.shrink();
  }

  Widget _buildExperienceSection(List<dynamic>? experiences) {
    if (experiences == null || experiences.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Experience:", style: TextStyle(fontWeight: FontWeight.bold)),
        ...experiences.map((exp) => Padding(
              padding: EdgeInsets.only(left: 10, top: 4),
              child: Text("- ${exp['position'] ?? "Unknown Position"} at ${exp['company'] ?? "Unknown Company"}"),
            )),
      ],
    );
  }
}

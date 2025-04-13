// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/const/core/color.dart';
import 'package:job_project/widget/text.dart';

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
  final TextEditingController educationController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int selectedExperience = 0; 

  void postJob(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You must be logged in to post a job!")),
      );
      return;
    }

    String title = titleController.text.trim();
    String company = companyController.text.trim();
    String salary = salaryController.text.trim();
    String location = locationController.text.trim();
    String description = descriptionController.text.trim();
    String education = educationController.text.trim();
    String skills = skillsController.text.trim();
    String experience = "$selectedExperience Years";

    if (title.isEmpty ||
        company.isEmpty ||
        salary.isEmpty ||
        location.isEmpty ||
        description.isEmpty ||
        education.isEmpty ||
        skills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields!")),
      );
      return;
    }
//firebase
    try {
      await _firestore.collection('jobs').add({
        'title': title,
        'company': company,
        'salary': salary,
        'location': location,
        'description': description,
        'education': education,
        'skills': skills,
        'experience': experience,
        'postedAt': FieldValue.serverTimestamp(),
        'recruiterId': user.uid,
        
      });

      // Clear fields after posting
      titleController.clear();
      companyController.clear();
      salaryController.clear();
      locationController.clear();
      descriptionController.clear();
      educationController.clear();
      skillsController.clear();
      setState(() {
        selectedExperience = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Job Posted Successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error posting job: $e")),
      );
    }
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
                "Post a Job",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Design.bottom,
                ),
              ),
            ),
          ),
    
         
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    text1(titleController, "Job Title"),
                    SizedBox(height: 10),
                    text1(companyController, "Company Name"),
                    SizedBox(height: 10),
                    text1(locationController, "Job Location"),
                    SizedBox(height: 10),
                    text1(salaryController, "Salary"),
                    SizedBox(height: 10),
                    text1(skillsController, "Required Skills"),
                    SizedBox(height: 10),
                    text1(educationController, "Education Required"),
                    SizedBox(height: 10),
    
                    
                    Row(
                      children: [
                        Text(
                          "Experience: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: SizedBox(
                            height: 80,
                            child: ListWheelScrollView.useDelegate(
                              itemExtent: 40,
                              perspective: 0.005,
                              diameterRatio: 2,
                              physics: FixedExtentScrollPhysics(),
                              controller: FixedExtentScrollController(
                                initialItem: selectedExperience,
                              ),
                              onSelectedItemChanged: (value) {
                                setState(() {
                                  selectedExperience = value;
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                builder: (context, index) {
                                  return Center(
                                    child: Text(
                                      "$index Years",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  );
                                },
                                childCount: 51, 
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
    
                  
                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Design.bottom,
                        labelText: "Job Description",
                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Design.baseColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Design.buttonColor,
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => postJob(context),
                      child: Text(
                        "Post Job",
                        style: TextStyle(
                          color: Design.bottom,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

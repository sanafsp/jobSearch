// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_project/const/core/color.dart';
import 'package:job_project/jobSeeker/notification.dart';
import 'package:job_project/login/signin.dart';
import 'package:job_project/widget/text.dart';

class JobSeekerProfileScreen extends StatefulWidget {
  final String userId;
  
  JobSeekerProfileScreen({required this.userId});

  @override
  _JobSeekerProfileScreenState createState() => _JobSeekerProfileScreenState();
}

class _JobSeekerProfileScreenState extends State<JobSeekerProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _linksController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _certificationsController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _resumeController = TextEditingController();
  final List<Map<String, String>> _experienceList = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    setState(() => _isLoading = true);

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('job_seekers')
        .doc(widget.userId)
        .get();

    if (userDoc.exists) {
      var data = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _nameController.text = data['name'] ?? "";
        _ageController.text = data['age'] ?? "";
        _addressController.text = data['address'] ?? "";
        _locationController.text = data['location'] ?? "";
        _phoneController.text = data['phone'] ?? "";
        _emailController.text = data['email'] ?? "";
        _linksController.text = data['links'] ?? "";
        _educationController.text = data['education'] ?? "";
        _certificationsController.text = data['certifications'] ?? "";
        _skillsController.text = data['skills'] ?? "";
        _resumeController.text = data['resume'] ?? "";
        
        if (data['experience'] != null) {
          _experienceList.clear();
          for (var exp in data['experience']) {
            _experienceList.add({
              'company': exp['company'] ?? "",
              'year': exp['year'] ?? "",
              'position': exp['position'] ?? "",
            });
          }
        }
      });
    }

    setState(() => _isLoading = false);
  }

  Future<void> _saveProfileData() async {
    setState(() => _isLoading = true);

    await FirebaseFirestore.instance.collection('job_seekers').doc(widget.userId).set({
      'name': _nameController.text.trim(),
      'age': _ageController.text.trim(),
      'address': _addressController.text.trim(),
      'location': _locationController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'links': _linksController.text.trim(),
      'education': _educationController.text.trim(),
      'certifications': _certificationsController.text.trim(),
      'skills': _skillsController.text.trim(),
      'resume': _resumeController.text.trim(),
      'experience': _experienceList,
    }, SetOptions(merge: true));

    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" Profile Updated Successfully!")));
  }

  void _addExperience() {
    setState(() => _experienceList.add({'company': "", 'year': "", 'position': ""}));
  }

  void _removeExperience(int index) {
    setState(() => _experienceList.removeAt(index));
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
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
            ),
            child:
            Column(children: [
             SizedBox(
              height: 100,
               child: Row(mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   IconButton(
                                             icon: Icon(Icons.logout, color: Design.bottom),
                                             onPressed: () {
                                               Navigator.push(
                                                 context,
                                                 MaterialPageRoute(builder: (context) => LoginPage()),
                                               );
                                             },
                                                                                ),
                ]),
             ),
              
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Job Seeker Profile",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Design.bottom),
                    ),
                  ],
                ),
             
            ],)
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        text1(_nameController, "Full Name"),
                        SizedBox(height: 10,),
                        text1(_ageController, "Age"),
                        SizedBox(height: 10,),
                        text1(_addressController, "Address"),
                        SizedBox(height: 10,),
                        text1(_locationController, "Location"),
                        SizedBox(height: 10,),
                        text1(_phoneController, "Phone Number"),
                        SizedBox(height: 10,),
                        text1(_emailController, "Email"),
                        SizedBox(height: 10,),
                        text1(_linksController, "Portfolio/LinkedIn Links"),
                        SizedBox(height: 10,),
                        text1(_educationController, "Education"),
                        SizedBox(height: 10,),
                        text1(_certificationsController, "Certifications"),
                        SizedBox(height: 10,),
                        text1(_skillsController, "Skills (Comma separated)"),
                        SizedBox(height: 10),
                        Text("Experience", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ..._experienceList.asMap().entries.map((entry) {
                          int index = entry.key;
                          return Column(
                            children: [
                              text1(TextEditingController(text: entry.value['company']), "Company Name"),
                              SizedBox(height: 10,),
                              text1(TextEditingController(text: entry.value['year']), "Year"),
                              SizedBox(height: 10,),
                              text1(TextEditingController(text: entry.value['position']), "Position"),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _removeExperience(index),
                                  ),
                                ElevatedButton.icon(
                          icon: Icon(Icons.add),
                          label: Text("Add Experience"),
                          onPressed: _addExperience,
                        ),
                                ],
                              ),
                             
                            ],
                          );
                        }).toList(),
                        
                         Divider(),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Design.buttonColor),
                          onPressed: _saveProfileData,
                          child: Text("Save Profile", style: TextStyle(color: Design.bottom)),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

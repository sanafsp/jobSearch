import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResumeScreen extends StatefulWidget {
  @override
  _ResumeScreenState createState() => _ResumeScreenState();
}

class _ResumeScreenState extends State<ResumeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _experience = '';
  String _skills = '';
  String _education = '';
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadResume();
  }

  //   Resume from SharedPreferences
  Future<void> _loadResume() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('resume_name') ?? '';
      _experience = prefs.getString('resume_experience') ?? '';
      _skills = prefs.getString('resume_skills') ?? '';
      _education = prefs.getString('resume_education') ?? '';
      _isEditing = _name.isNotEmpty; 
    });
  }

  //  Save Resume to Firebase Firestore & SharedPreferences
  Future<void> _saveResume() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    Map<String, String> resumeData = {
      'name': _name,
      'experience': _experience,
      'skills': _skills,
      'education': _education,
    };

    try {
      await FirebaseFirestore.instance.collection('resumes').doc('USER_ID').set(resumeData);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('resume_name', _name);
      prefs.setString('resume_experience', _experience);
      prefs.setString('resume_skills', _skills);
      prefs.setString('resume_education', _education);

      setState(() {
        _isEditing = true; 
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" Resume Saved Successfully!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" Failed to Save Resume!")));
    }
  }

  //  Delete Resume from Firebase & SharedPreferences
  Future<void> _deleteResume() async {
    await FirebaseFirestore.instance.collection('resumes').doc('USER_ID').delete();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('resume_name');
    prefs.remove('resume_experience');
    prefs.remove('resume_skills');
    prefs.remove('resume_education');

    setState(() {
      _name = '';
      _experience = '';
      _skills = '';
      _education = '';
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(" Resume Deleted Successfully!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Upload Resume")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) => value!.isEmpty ? "Enter your name" : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _experience,
                decoration: InputDecoration(labelText: "Experience"),
                validator: (value) => value!.isEmpty ? "Enter experience" : null,
                onSaved: (value) => _experience = value!,
              ),
              TextFormField(
                initialValue: _skills,
                decoration: InputDecoration(labelText: "Skills"),
                validator: (value) => value!.isEmpty ? "Enter skills" : null,
                onSaved: (value) => _skills = value!,
              ),
              TextFormField(
                initialValue: _education,
                decoration: InputDecoration(labelText: "Education"),
                validator: (value) => value!.isEmpty ? "Enter education" : null,
                onSaved: (value) => _education = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveResume,
                child: Text(_isEditing ? "Update Resume" : "Save Resume"),
              ),
              if (_isEditing)
                TextButton(
                  onPressed: _deleteResume,
                  child: Text("Delete Resume", style: TextStyle(color: Colors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

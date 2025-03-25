import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget { 
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void updateProfile() async {
    String userID = _auth.currentUser!.uid;
    await _firestore.collection('users').doc(userID).update({'name': nameController.text});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Updated")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: updateProfile, child: Text("Update Profile")),
          ],
        ),
      ),
    );
  }
}

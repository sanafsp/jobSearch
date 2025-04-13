// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_project/const/core/color.dart';
import 'package:job_project/login/signin.dart';
import 'package:job_project/widget/text.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  // fetch user profile data from Firestore
  Future<void> getUserData() async {
    String userID = _auth.currentUser!.uid;
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userID).get();

    if (userDoc.exists) {
      Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
      setState(() {
        nameController.text = data['name'] ?? '';
        addressController.text = data['address'] ?? '';
        locationController.text = data['location'] ?? '';
        phoneController.text = data['phone'] ?? '';
        emailController.text = data['email'] ?? _auth.currentUser!.email!;
        websiteController.text = data['website'] ?? '';
      });
    }
  }

  // update profile data in Firestore
  void updateProfile() async {
    String userID = _auth.currentUser!.uid;

    try {
      await _firestore.collection('users').doc(userID).update({
        'name': nameController.text.trim(),
        'address': addressController.text.trim(),
        'location': locationController.text.trim(),
        'phone': phoneController.text.trim(),
        'email': emailController.text.trim(),
        'website': websiteController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Profile Updated Successfully!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating profile: $e")));
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.baseColor,
     
      body: SingleChildScrollView(
        child: Column(
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
              child: Column(
                children: [
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
                                                                                       ],
                    ),
                  ),
               
                  Center(
                    child: Text(
                     "Profile",
                     
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Design.bottom),
                    ),
                  ),
                   ],
              ),
               
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                text1(nameController,"Name")  ,  
                SizedBox(height: 10,),
                text1(addressController,"Address")  ,  
                SizedBox(height: 10,),  
                text1(locationController,"Location")  ,
                SizedBox(height: 10,),
                text1(phoneController,"Phone Number")  , 
                SizedBox(height: 10,),    
                text1(emailController,"Email ID")   , 
                SizedBox(height: 10,), 
                text1(websiteController,"Website Link")   ,    
                      
                   
                  ],
                ),
              ),
            ),
           
          
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Design.buttonColor),
              onPressed: updateProfile,
              child: Text("Update Profile",style: TextStyle(fontWeight: FontWeight.bold,color: Design.bottom),),
            ),
          ],
        ),
      ),
    );
  }
}

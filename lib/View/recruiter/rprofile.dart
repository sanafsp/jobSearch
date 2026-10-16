// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/Repository/local_storage.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/View/jobSeeker/profile.dart';
import 'package:job_project/View/jobSeeker/resume.dart';
import 'package:job_project/View/login/signin.dart';
import 'package:job_project/View/recruiter/profileScreen.dart';

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
class RecruiterProfile extends StatefulWidget {
  final String userId;
  const RecruiterProfile({required this.userId});

  @override
  State<RecruiterProfile> createState() => _RecruiterProfileState();
}

class _RecruiterProfileState extends State<RecruiterProfile> {
  
  // Function to change the password
  Future<void> _changePassword() async {
    try {
      String currentPassword = _currentPasswordController.text;
      String newPassword = _newPasswordController.text;
      String confirmPassword = _confirmPasswordController.text;

      // Check if new password and confirm password match
      if (newPassword != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("New passwords do not match")),
        );
        return;
      }

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Reauthenticate the user
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);

        // Change the password
        await user.updatePassword(newPassword);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password changed successfully")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error changing password: $e")),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Design.baseColor,
     body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Design.buttonColor,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                     
                    ],
                  ),
                ),
                Center(
                  child: Text(
                    "Company Profile",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Design.bottom),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30,),
          TextButton(onPressed: (){
             Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfileScreen()
                              ),
                            );
            
          }, child: Text("Set Company information",
           style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal, color: Design.heading),)),
Divider(color: Design.bottom,thickness: 2,height: 0.5,),
         
Divider(color: Design.bottom,thickness: 2,height: 0.5,),
         

           TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Change Password',
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _currentPasswordController,
                                        obscureText: true,
                                        decoration: InputDecoration(labelText: 'Current Password'),
                                      ),
                                      TextField(
                                        controller: _newPasswordController,
                                        obscureText: true,
                                        decoration: InputDecoration(labelText: 'New Password'),
                                      ),
                                      TextField(
                                        controller: _confirmPasswordController,
                                        obscureText: true,
                                        decoration: InputDecoration(labelText: 'Confirm New Password'),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Cancel'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        await _changePassword();
                                        Navigator.pop(context);
                                      },
                                      child: Text('Change Password',
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }, child: Text("Change Password",
                           style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal, color: Design.heading)),
                        ),
                        Divider(color: Design.bottom,thickness: 2,height: 0.5,),
          TextButton(onPressed: (){

   showGeneralDialog(
  context: context,
  barrierDismissible: true,
  barrierLabel: "Logout",
  barrierColor: Colors.black54,
  transitionDuration: const Duration(milliseconds: 300),

  pageBuilder: (context, animation, secondaryAnimation) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Text(
        "Logout",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: const Text(
        "Are you sure you want to logout?",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancel"),
        ),

        ElevatedButton(
          onPressed: () async {
            // Close dialog first
            Navigator.pop(context);

            // Delete saved user information
            await FirebaseAuth.instance.signOut();
            await LocalStorage.deleteLoggedUserInfo();

            // Go to Login page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(),
              ),
            );
          },
          child: const Text("Logout"),
        ),
      ],
    );
  },

  transitionBuilder: (
    context,
    animation,
    secondaryAnimation,
    child,
  ) {
    // Right → Left animation
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;

    final tween = Tween(
      begin: begin,
      end: end,
    ).chain(
      CurveTween(
        curve: Curves.easeOut,
      ),
    );

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  },
);



            //  Navigator.pushReplacement(
            //                 context,
            //                 MaterialPageRoute(builder: (context) => LoginPage()),
            //               );
          }, child: Text("Logout", style: TextStyle(fontSize: 17, fontWeight: FontWeight.normal, color: Design.heading)))

          ])
          );
    
  }
}
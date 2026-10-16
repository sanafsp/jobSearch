import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/View/recruiter/application.dart';
import 'package:job_project/View/recruiter/recruiter_home.dart';
import 'package:job_project/View/recruiter/posting.dart';
import 'package:job_project/View/recruiter/profileScreen.dart';
import 'package:job_project/View/recruiter/rprofile.dart';

class Companybottom extends StatefulWidget {
  const Companybottom({super.key});

  @override
  State<Companybottom> createState() => _CompanybottomState();
}

class _CompanybottomState extends State<Companybottom> {
  int selected = 0;
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

  @override
  Widget build(BuildContext context) {
    String recruiterId = FirebaseAuth.instance.currentUser?.uid ?? "";

    List<Widget> pages = [
      CompanyJobsScreen(),
      PostJobScreen(),
      RecruiterJobApplicationsScreen(recruiterId: recruiterId), 
      
      RecruiterProfile(userId:userId,)
    ];

    return Scaffold(
      body: pages[selected],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selected,
        backgroundColor: Design.bottom,
        selectedItemColor: Design.buttonColor,
        unselectedItemColor: Design.bottomIcon,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Tooltip(
          message: "Home screen",child: Icon(Icons.home, size: 30)), label: "Home"),
          BottomNavigationBarItem(icon:  Tooltip(
          message: "Post a job",child: Icon(Icons.post_add, size: 30)), label: "Post Job"),
          BottomNavigationBarItem(icon:  Tooltip(
          message: "Received Applications",child: Icon(Icons.inbox, size: 30)), label: "Received Applications"),
          // BottomNavigationBarItem(icon: Icon(Icons.account_circle, size: 30), label: "Exam"),
        ],
        onTap: (index) {
          setState(() {
            selected = index;
          });
        },
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/const/core/color.dart';
import 'package:job_project/recruiter/application.dart';
import 'package:job_project/recruiter/chome.dart';
import 'package:job_project/recruiter/posting.dart';
import 'package:job_project/recruiter/profileScreen.dart';

class Companybottom extends StatefulWidget {
  const Companybottom({super.key});

  @override
  State<Companybottom> createState() => _CompanybottomState();
}

class _CompanybottomState extends State<Companybottom> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    String recruiterId = FirebaseAuth.instance.currentUser?.uid ?? "";

    List<Widget> pages = [
      CompanyJobsScreen(),
      PostJobScreen(),
      RecruiterJobApplicationsScreen(recruiterId: recruiterId), 
      ProfileScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.home, size: 30), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.post_add, size: 30), label: "Exam"),
          BottomNavigationBarItem(icon: Icon(Icons.inbox, size: 30), label: "Feedback"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle, size: 30), label: "Exam"),
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

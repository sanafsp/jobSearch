import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/const/core/color.dart';
import 'package:job_project/jobSeeker/profile.dart';
import 'package:job_project/jobSeeker/saveJob.dart';
import 'package:job_project/jobSeeker/joblist.dart';
import 'package:job_project/recruiter/posting.dart';
import 'package:job_project/recruiter/profileScreen.dart';

class Workersbottom extends StatefulWidget {
  const Workersbottom({super.key});

  @override
  State<Workersbottom> createState() => _CompanybottomState();
}

class _CompanybottomState extends State<Workersbottom> {
  int selected = 0;
   final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

  @override
  Widget build(BuildContext context) {
    
    List<Widget> pages = [
      JobListScreen(),
     SavedJobsScreen(),
      JobSeekerProfileScreen(userId:userId,),
      
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
          BottomNavigationBarItem(icon: Icon(Icons.assignment, size: 30), label: "Exam"),
          BottomNavigationBarItem(icon: Icon(Icons.feedback, size: 30), label: "Feedback"),
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

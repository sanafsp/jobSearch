import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/const/core/color.dart';
import 'package:job_project/jobSeeker/applied.dart';
import 'package:job_project/jobSeeker/apply.dart';
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
      AppliedJobsScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.bookmark, size: 30), label: "Exam"),
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

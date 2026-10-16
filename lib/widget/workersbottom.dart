import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/View/admin/admin_home.dart';
import 'package:job_project/View/jobSeeker/premium_details.dart';
import 'package:job_project/constants/core/color.dart';
import 'package:job_project/View/jobSeeker/applied.dart';
import 'package:job_project/View/jobSeeker/apply.dart';
import 'package:job_project/View/jobSeeker/profile.dart';
import 'package:job_project/View/jobSeeker/saveJob.dart';
import 'package:job_project/View/jobSeeker/seeker_home.dart';
import 'package:job_project/View/recruiter/posting.dart';
import 'package:job_project/View/recruiter/profileScreen.dart';

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
      // JobSeekerProfileScreen(userId:userId,),
      // Seekerprofile(userId:userId,),

      PremiumScreen(),

      
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
          BottomNavigationBarItem(icon: Icon(Icons.bookmark, size: 30), label: "Save"),
          BottomNavigationBarItem(icon: Icon(Icons.inbox, size: 30), label: "Jobs"),
          BottomNavigationBarItem(icon: Icon(Icons.workspace_premium_outlined, size: 30), label: "Premium"),
          
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

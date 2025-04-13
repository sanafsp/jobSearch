// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue, // Background color
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Center(
              
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

  // // ✅ Skills Section
  //           if (jobData['skills'] != null && (jobData['skills'] as List).isNotEmpty) ...[
  //             Text("💡 Skills Required:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //             SizedBox(height: 8),
  //             Wrap(
  //               spacing: 8,
  //               children: (jobData['skills'] as List).map<Widget>((skill) => Chip(label: Text(skill))).toList(),
  //             ),
  //             SizedBox(height: 16),
  //           ],

  //           // ✅ Education Section
  //           if (jobData['education'] != null) ...[
  //             Text("🎓 Education Required:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //             SizedBox(height: 8),
  //             Text(jobData['education'], style: TextStyle(fontSize: 16)),
  //             SizedBox(height: 16),
  //           ],

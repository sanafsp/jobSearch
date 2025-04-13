import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_project/const/core/color.dart';
import 'package:job_project/widget/workersbottom.dart';
import 'package:share_plus/share_plus.dart';
import 'package:job_project/jobSeeker/applied.dart';

class JobDetailScreen extends StatefulWidget {
  final String jobId;

  JobDetailScreen({required this.jobId});

  @override
  _JobDetailScreenState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool _isEligible = false; 
  Map<String, dynamic>? jobData;
  String recruiterId = "";

  @override
  void initState() {
    super.initState();
    _fetchJobDetails();
  }

  //  Fetch Job Details from Firestore
  Future<void> _fetchJobDetails() async {
    try {
      DocumentSnapshot jobSnapshot = await FirebaseFirestore.instance
          .collection('jobs')
          .doc(widget.jobId)
          .get();

      if (jobSnapshot.exists) {
        setState(() {
          jobData = jobSnapshot.data() as Map<String, dynamic>;
          recruiterId = jobData?['recruiterId'] ?? "";
        });

        //  Check job seeker eligibility
        _checkEligibility();
      }
    } catch (e) {
      print("Error fetching job details: $e");
    }
  }

  //  Check if Job Seeker is Eligible
  Future<void> _checkEligibility() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "Guest";
    if (userId == "Guest") return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('job_seekers')
          .doc(userId)
          .get();

      if (!userDoc.exists) return;

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      //  Convert Firestore data safely
      List<String> jobSkills = _convertToStringList(jobData?['skills']);
      List<String> seekerSkills = _convertToStringList(userData['skills']);

      //  Convert both skill lists to lowercase for case-insensitive matching
      jobSkills = jobSkills.map((e) => e.toLowerCase()).toList();
      seekerSkills = seekerSkills.map((e) => e.toLowerCase()).toList();

      //  Convert experience values to numbers for comparison
      int jobExperience = _convertToInt(jobData?['experience']);
      int seekerExperience = _convertToInt(userData['experience']);

      //  Check if all job-required skills exist in seeker skills
      bool skillsMatch = jobSkills.every((skill) => seekerSkills.contains(skill));

      //  Check if seeker has equal or greater experience than required
      bool experienceMatch = seekerExperience >= jobExperience;

      setState(() {
        _isEligible = skillsMatch && experienceMatch;
      });

      print(" Eligibility Check: Skills Match: $skillsMatch, Experience Match: $experienceMatch");
    } catch (e) {
      print(" Error checking eligibility: $e");
    }
  }

  //  Convert Firestore List<dynamic> or String to List<String>
  List<String> _convertToStringList(dynamic data) {
    if (data is List) {
      return data.map((e) => e.toString().trim()).toList();
    } else if (data is String) {
      return data.split(",").map((s) => s.trim()).toList();
    }
    return [];
  }

  //  Convert Experience to Integer Safely
  int _convertToInt(dynamic data) {
    if (data is int) return data;
    if (data is String) {
      return int.tryParse(data) ?? 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    if (jobData == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
       backgroundColor: Design.baseColor,
      appBar: AppBar(
        backgroundColor: Design.buttonColor,
        title: Text(jobData?['title'] ?? "Job Details",style: TextStyle(color: Design.bottom),),
        leading: IconButton(onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>Workersbottom()));
        }, icon: Icon(Icons.arrow_back_ios_new,color: Design.bottom)),
        actions: [
          IconButton(
            icon: Icon(Icons.share,color: Design.bottom),
            onPressed: () => _shareJob(context),
          ),
        ],
      ),
      body:
    
         Column(
          children: [
         
                   SizedBox(height: 20,),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    Text("🏢  ${jobData?['company'] ?? 'Unknown'}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text("📍 Location: ",style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal,color: Design.heading)),
                        Text("${jobData?['location'] ?? 'Not mentioned'}",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Design.heading))
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text("💰 Salary:",style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal,color: Design.heading)),
                        Text(" ${jobData?['salary'] != null ? '\$${jobData?['salary']}' : 'N/A'}",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Design.heading)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text("📅 Experience:",style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal,color: Design.heading)),
                         Text("${jobData?['experience'] ?? 'Not mentioned'}",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Design.heading))
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text("💡 Skills Required:",style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal,color: Design.heading)),
                        Text(" ${jobData?['skills'] ?? 'Not mentioned'}",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Design.heading)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text("🎓 Education: ",style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal,color: Design.heading),),
                        Text("${jobData?['education'] ?? 'Not mentioned'}",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Design.heading)),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text("📜 Job Description:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text(jobData?['description'] ?? "No description provided.", style: TextStyle(fontSize: 16)),
                    SizedBox(height: 20),
                
                  
                    Center(
                      child: ElevatedButton(
                        onPressed: _isEligible
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JobApplicationScreen(
                                      jobId: widget.jobId,
                                      recruiterId: recruiterId,
                                    ),
                                  ),
                                );
                              }
                            : () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(" You do not meet the required skills/experience.")),
                                );
                              },
                        child: Text("Apply Now",style: TextStyle(color: Design.bottom),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isEligible ? Design.buttonColor: Colors.grey, 
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      // ),
    );
  }

  //  Share Job Details
  void _shareJob(BuildContext context) async {
    try {
      String jobTitle = jobData?['title'] ?? "Job Opportunity";
      String company = jobData?['company'] ?? "Unknown Company";
      String location = jobData?['location'] ?? "Not mentioned";
      String salary = jobData?['salary'] != null ? '\$${jobData?['salary']}' : 'N/A';
      String description = jobData?['description'] ?? "No description available.";

      String shareText = """
📢 Job Opportunity: $jobTitle
🏢 Company: $company
📍 Location: $location
💰 Salary: $salary
📝 Description: $description

Apply now on our job portal! 🚀
""";

      await Share.share(shareText);
    } catch (e) {
      print(" Error sharing job: $e");
    }
  }
}

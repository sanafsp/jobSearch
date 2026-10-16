import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/widget/workersbottom.dart';
import 'package:share_plus/share_plus.dart';
import 'package:job_project/View/jobSeeker/applied.dart';

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
    
    

 SingleChildScrollView(
  physics: const BouncingScrollPhysics(),
  child: Padding(
    padding: const EdgeInsets.only(
      top: 20,
      bottom: 30,
    ),
  child: Column(
    children: [
      const SizedBox(height: 20),
  
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          color: Colors.white,
          elevation: 4,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
  
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Design.buttonColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.business_rounded,
                        color: Design.buttonColor,
                        size: 30,
                      ),
                    ),
  
                    const SizedBox(width: 14),
  
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Company",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
  
                          const SizedBox(height: 3),
  
                          Text(
                            jobData?['company'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
  
                const SizedBox(height: 22),
  
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    children: [
  
                      _jobDetailRow(
                        Icons.location_on_outlined,
                        "Location",
                        jobData?['location'] ?? 'Not mentioned',
                      ),
  
                      const Divider(height: 22),
  
                      _jobDetailRow(
                        Icons.currency_rupee_rounded,
                        "Salary",
                        jobData?['salary'] != null
                            ? "₹${jobData?['salary']}"
                            : "N/A",
                      ),
  
                      const Divider(height: 22),
  
                      _jobDetailRow(
                        Icons.work_outline_rounded,
                        "Experience",
                        jobData?['experience'] ?? 'Not mentioned',
                      ),
  
                      const Divider(height: 22),
  
                      _jobDetailRow(
                        Icons.school_outlined,
                        "Education",
                        jobData?['education'] ?? 'Not mentioned',
                      ),
  
                      const Divider(height: 22),
  
                      _jobDetailRow(
                        Icons.lightbulb_outline_rounded,
                        "Skills",
                        jobData?['skills'] ?? 'Not mentioned',
                      ),
                    ],
                  ),
                ),
  
                const SizedBox(height: 24),
  
               
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Design.buttonColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
  
                    const SizedBox(width: 10),
  
                    const Text(
                      "Job Description",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
  
                const SizedBox(height: 10),
  
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Design.buttonColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text( 
                    jobData?['description'] ??
                        "No description provided.",
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ),
  
                const SizedBox(height: 25),
  
                
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isEligible
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    JobApplicationScreen(
                                  jobId: widget.jobId,
                                  recruiterId: recruiterId,
                                ),
                              ),
                            );
                          }
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "You do not meet the required skills/experience.",
                                ),
                              ),
                            );
                          },
  
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isEligible
                          ? Design.buttonColor
                          : Colors.grey.shade400,
  
                      foregroundColor: Colors.white,
  
                      elevation: 2,
  
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
  
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isEligible
                              ? Icons.send_rounded
                              : Icons.lock_outline_rounded,
                          size: 20,
                        ),
  
                        const SizedBox(width: 8),
  
                        Text(
                          _isEligible
                              ? "View Details"
                              : "Not Eligible",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
)
  
                 ),
      // ),
    );
  }

  Widget _jobDetailRow(
  IconData icon,
  String title,
  String value,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Design.buttonColor.withOpacity(0.10),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: Design.buttonColor,
          size: 21,
        ),
      ),

      const SizedBox(width: 12),

      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Design.heading,
              ),
            ),
          ],
        ),
      ),
    ],
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

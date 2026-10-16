// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/View/recruiter/recruiter_drawer.dart';

class CompanyJobsScreen extends StatefulWidget {
  @override
  State<CompanyJobsScreen> createState() => _CompanyJobsScreenState();
}

class _CompanyJobsScreenState extends State<CompanyJobsScreen> {


final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

void openDrawer() {

  print('clicked open drawer');
  _scaffoldKey.currentState?.openDrawer();
}




  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
         key: _scaffoldKey,
        appBar: AppBar(title: Text("Your Jobs")),
        body: Center(child: Text("Please log in to view your jobs.")),
      );
    }

    return Scaffold(
       key: _scaffoldKey,
      drawer: CompanyDrawer(userId: user.uid),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('recruiterId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No jobs posted yet."));
          }

          var jobs = snapshot.data!.docs;

          return Column(
            children: [
              
              SingleChildScrollView(
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
                      child: 
                          Column(
                       children: [
                         Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [

                             SizedBox(
                                          // width: 500,
                                          height: 100,
                                           child: IconButton(
                                           icon: Icon(Icons.menu, color: Design.bottom),
                                           onPressed: () {
                                            print('tapped on press of drawer');
                                             openDrawer();
                                           },
                                                                              ),
                                         ),
                            
                                        //  SizedBox(
                                        //   // width: 500,
                                        //   height: 100,
                                        //    child: IconButton(
                                        //    icon: Icon(Icons.notifications, color: Design.bottom),
                                        //    onPressed: () {
                                        //      Navigator.push(
                                        //        context,
                                        //        MaterialPageRoute(builder: (context) => NotificationScreen()),
                                        //      );
                                        //    },
                                        //                                       ),
                                        //  ),
                                          ],
                         ),
                             Center(
                               child: 
                                   Row(mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Text(
                                                    jobs.isNotEmpty
                              ? "🏢 ${jobs[0]['company']}"
                              : "Your Posted Jobs",
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(fontSize: 25, 
                                                          fontWeight: FontWeight.bold,
                                                          color: Design.bottom),
                                                        ),
                                     
                         
                                 ],
                               ),
                             ),
                          
                       ],
                     ),
                   ),
                   SizedBox(height: 20,),
                      
                      // Center(
                      //   child: Text(
                          // jobs.isNotEmpty
                          //     ? "🏢 ${jobs[0]['company']}"
                          //     : "Your Posted Jobs",
                      //     textAlign: TextAlign.center,
                      //     style: TextStyle(
                      //       fontSize: 25,
                      //       fontWeight: FontWeight.bold,
                      //       color: Design.bottom,
                      //     ),
                      //   ),
                      // ),
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    var job = jobs[index].data() as Map<String, dynamic>;
                    String jobId = jobs[index].id;

                    return Card(
                      color: Design.bottom,
                      elevation: 10,
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                          job['title'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "🏢  ${job['company']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              "📍  ${job['location']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 15),
                            ),
                            Text(
                              "💰  ${job['salary']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 15),
                            ),
                            Text(
                              "Experience: ${job['experience']} years",
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 15),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => showDeleteDialog(context, jobId),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Function to show delete confirmation dialog
  void showDeleteDialog(BuildContext context, String jobId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Job"),
        content: Text(
            "Are you sure you want to delete this job? All applications will also be deleted."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await deleteJob(jobId, context);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Function to delete a job and related job applications
  Future<void> deleteJob(String jobId, BuildContext context) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Step 1: Delete the job from 'jobs' collection
      await firestore.collection('jobs').doc(jobId).delete();

      // Step 2: Find and delete all related job applications
      final applicationsSnapshot = await firestore
          .collection('job_applications')
          .where('jobId', isEqualTo: jobId)
          .get();

      for (var doc in applicationsSnapshot.docs) {
        await firestore.collection('job_applications').doc(doc.id).delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Job and related applications deleted.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting job: $e")),
      );
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_project/Constants/app_styles.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/View/admin/admin_drawer.dart';

import 'package:job_project/View/admin/interview_management.dart';
import 'package:job_project/View/admin/total_hireseekers.dart';
import 'package:job_project/View/admin/total_jobseekers.dart';
import 'package:job_project/View/admin/total_premiumuser.dart';
import 'package:job_project/View/admin/total_recruiter.dart';
import 'package:job_project/Constants/app_styles.dart';

class AdminHomeScreen extends StatelessWidget {
   AdminHomeScreen({super.key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

void openDrawer() {
  _scaffoldKey.currentState?.openDrawer();
}

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
  value: AppStyles.appStatusBarStyle,
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FC),
         key: _scaffoldKey,
      drawer: AdminDrawer(userId: FirebaseAuth.instance.currentUser!.uid,),
      
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users',)
                .snapshots(),
      
            builder: (context, userSnapshot) {
              int jobSeekers = 0;
              int recruiters = 0;
              int premiumUsers = 0;
      
              if (userSnapshot.hasData) {
                for (final doc in userSnapshot.data!.docs) {
                  final data =
                      doc.data() as Map<String, dynamic>;
      
                  final role = (data['rool'] ?? '')
                      .toString()
                      .trim()
                      .toLowerCase()
                      .replaceAll('_', '')
                      .replaceAll('-', '')
                      .replaceAll(' ', '');
                  if (
                      role == 'workers') {
                    jobSeekers++;
                  }
      
                  if (
                      role == 'company') {
                    recruiters++;
                  }
      
                  if (data['isPremium'] == true) {
                    premiumUsers++;
                  }
                }
              }
      
              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('job_applications')
                   
                    .snapshots(),
      
                builder: (
                  context,
                  applicationSnapshot,
                ) {
                  int hireSeekers = 0;
      
                  if (applicationSnapshot.hasData) {
                     for (final doc
                    in applicationSnapshot.data!.docs) {
                  final data =
                      doc.data()
                          as Map<String, dynamic>;
                         final status = (data['status'] ?? '')
                      .toString()
                      .trim()
                      .toLowerCase()
                      .replaceAll('_', '')
                      .replaceAll('-', '')
                      .replaceAll(' ', '');
                        if (status == 'hired') {
            hireSeekers++;
                  }
                    }
                  }
      
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
               Container(
                        height: 200,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [

                              IconButton(onPressed: (){

                              openDrawer();

                              }, icon: Icon(Icons.menu_rounded,color: Colors.white,)),

                              SizedBox(width: 20,)
                            ],),
                            SizedBox(height: 20,),
                            Center(
                              child: Text(
                                "Welcome Admin",
                                textAlign: TextAlign.center,
                                style: AppStyles.authGreetingTextStyle,
                              ),
                            ),
                             SizedBox(height: 7),
                          ],
                        ),
                      
                      ),
                    // OVERVIEW TITLE
                    Padding(
                       padding: const EdgeInsets.all(16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [ 
                      const SizedBox(height: 13),
                      
                      // FOUR CARDS
                      
                      GridView.count(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 700
                                ? 4
                                : 2,
                      
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      
                        childAspectRatio:
                            MediaQuery.of(context).size.width > 700
                                ? 1.20
                                : 0.85,
                      
                        shrinkWrap: true,
                      
                        physics:
                            const NeverScrollableScrollPhysics(),
                      
                        children: [
                          // JOB SEEKERS
                          _dashboardCard(
                            context,
                      
                            title: "All Job Seekers",
                      
                            count: jobSeekers,
                      
                            subtitle:
                                "Registered job seekers",
                      
                            icon:
                                Icons.people_alt_rounded,
                      
                            color:
                                const Color(0xFF3B82F6),
                      
                            page:
                                const JobSeekersPage(),
                          ),
                      
                          // RECRUITERS
                          _dashboardCard(
                            context,
                      
                            title: "All Recruiters",
                      
                            count: recruiters,
                      
                            subtitle:
                                "Registered recruiters",
                      
                            icon:
                                Icons.business_center_rounded,
                      
                            color:
                                const Color(0xFF8B5CF6),
                      
                            page:
                                const RecruitersPage(),
                          ),
                      
                          // PREMIUM
                          _dashboardCard(
                            context,
                      
                            title: "Premium Users",
                      
                            count: premiumUsers,
                      
                            subtitle:
                                "Active premium users",
                      
                            icon:
                                Icons
                                    .workspace_premium_rounded,
                      
                            color:
                                const Color(0xFFF59E0B),
                      
                            page:
                                const PremiumUsersPage(),
                          ),
                      
                          // HIRE SEEKERS
                          _dashboardCard(
                            context,
                      
                            title: "All Hire Seekers",
                      
                            count: hireSeekers,
                      
                            subtitle:
                                "Recruiters looking to hire",
                      
                            icon:
                                Icons.person_search_rounded,
                      
                            color:
                                const Color(0xFF10B981),
                      
                            page:
                                const HireSeekersPage(),
                          ),
                        ],
                      ),
                               const SizedBox(height: 13),
                     GestureDetector(onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>
                       
                       InterviewManagement()
                      //  InterviewContent()
                       
                       ));
                     },
                       child: Container( width: double.infinity,
                        padding: const EdgeInsets.all(20),
                         decoration: BoxDecoration( color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [ BoxShadow( color: Colors.black.withOpacity(.05),
                          blurRadius: 15,
                           offset: const Offset(0, 5),
                            ), ],
                            ), 
                          child: Row(mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row( 
                                children: [ 
                                  Container( height: 50, width: 50, 
                                  decoration: BoxDecoration( color: Design.buttonColor.withOpacity(.1),
                                   borderRadius: BorderRadius.circular(14), ),
                                                 child:
                                                  Icon( Icons.admin_panel_settings_rounded, 
                                                  color: Design.buttonColor, size: 28, ), 
                                                  ),],
                                            ),
                                            SizedBox(width: size.width*.05,),
                                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Interview",style: TextStyle(
                                         fontSize: 15,
                                         fontWeight: FontWeight.bold,
                                       ),),
                                                 const SizedBox(height: 5),
                                                Text('Manage interview settings.',style: TextStyle(
                                         color: Colors.grey.shade600,
                                         fontSize: 10,
                                       ),)
                                              ],
                                            )
                            ],
                       
                            
                          ),
                                    ),
                     )
              ]
               )
                )
              ]
            )
           );
              
            });
            }
          ),
        ),
      ),
    );
  }

  // DASHBOARD CARD

  Widget _dashboardCard(
    BuildContext context, {
    required String title,
    required int count,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(22),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => page,
            ),
          );
        },

        child: Container(
          padding: const EdgeInsets.all(17),

          decoration: BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.circular(22),

            border: Border.all(
              color: Colors.grey.shade100,
            ),

            boxShadow: [
              BoxShadow(
                color:
                    Colors.black.withOpacity(.055),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              // TOP
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [
                  Container(
                    height: 46,
                    width: 46,

                    decoration: BoxDecoration(
                      color: color.withOpacity(.11),
                      borderRadius:
                          BorderRadius.circular(14),
                    ),

                    child: Icon(
                      icon,
                      color: color,
                      size: 24,
                    ),
                  ),

                  Container(
                    height: 31,
                    width: 31,

                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey.shade600,
                      size: 17,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // NUMBER
              Text(
                count.toString(),

                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF172033),
                ),
              ),

              const SizedBox(height: 2),

              // TITLE
              Text(
                title,

                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,

                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF30384A),
                ),
              ),

              const SizedBox(height: 4),

              // SUBTITLE
              Text(
                subtitle,

                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,

                style: TextStyle(
                  fontSize: 10.5,
                  color:
                      Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
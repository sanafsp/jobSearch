import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_project/Constants/app_styles.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/View/admin/interview_preparation.dart';


class InterviewManagement extends StatelessWidget {
  const InterviewManagement({super.key});

  @override
  Widget build(BuildContext context) {
    
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Design.buttonColor,
        foregroundColor: Colors.white,
        elevation: 0,
        systemOverlayStyle:AppStyles.appStatusBarStyle,
        title:  Text(
            
           'Interview Management',
          style: AppStyles.appBarTitleStyle,
        ),
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // _welcomeCard(),
          
                const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                children: [
          
                 RichText(
                  
                  text: TextSpan(
                  children: [
                    
                    TextSpan(text: 'Let\'s Setup \n\n',style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 17,
                  ),),
          
                   TextSpan(text: ' Interview Details',style: TextStyle(
                    color: Colors.black,
                    fontSize: 19,fontWeight: FontWeight.w700
                  ),)
                  ]
                 )),
          
                ])),
          
                SizedBox(
                  width: size.width/2.2,
                  child: Divider(thickness: 1,color: Design.buttonColor,)),
              
                
                const SizedBox(height: 18),
                
                _contentCard(
                  context,
                  collection: 'interview_preparation',
                  icon: Icons.menu_book_rounded,
                  title: 'Interview Preparation',
                  subtitle:
                      'Add and manage interview preparation materials.',
                  color: Design.buttonColor,
                ),
                
                _contentCard(
                  context,
                  collection: 'mock_interview',
                  icon: Icons.record_voice_over_outlined,
                  title: 'Mock Interview',
                  subtitle:
                      'Add and manage mock interview questions.',
                  color: Colors.deepPurple,
                ),
                
                _contentCard(
                  context,
                  collection: 'interview_questions_answers',
                  icon: Icons.question_answer_outlined,
                  title: 'Interview Questions & Answers',
                  subtitle:
                      'Manage interview questions, answers and tips.',
                  color: Colors.teal,
                ),
                        
          
          
           
            ],
          ),
        ),
      ),
    );
  }

  Widget _contentCard(
    BuildContext context, {
    required String collection,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection(collection)
          .snapshots(),
      builder: (context, snapshot) {
        int count = 0;

        if (snapshot.hasData) {
          count = snapshot.data!.docs.length;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => InterviewContentAdminScreen(
                    collection: collection,
                    title: title,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(17),
              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey.shade600,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$count items',
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: Colors.grey.shade500,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
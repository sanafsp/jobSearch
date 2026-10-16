import 'package:flutter/material.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/Controller/payment_controller.dart';
import 'package:job_project/View/jobSeeker/interview_preparation.dart';
import 'package:job_project/View/jobSeeker/interview_qna.dart';
import 'package:job_project/View/jobSeeker/mock_interview.dart';

class PremiumBenefitsPage extends StatelessWidget {
  PremiumBenefitsPage({
    super.key,
    required this.paymentController,
  });

  final PaymentController paymentController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios)),
        elevation: 0,
        backgroundColor: Design.buttonColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Premium",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Design.buttonColor,
                      Design.buttonColor.withOpacity(0.75),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.workspace_premium,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "You are a Premium User",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Enjoy all premium job seeker features.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // expiry date

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Row(
                        children: [

                          const Icon(
                            Icons.event,
                            color: Colors.white,
                            size: 22,
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [

                                const Text(
                                  "Premium Valid Until",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),

                                const SizedBox(height: 3),

                                Text(
                                  paymentController
                                      .premiumExpiryDateText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
   
              const Text(
                "Your Premium Benefits",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              _benefitItem(
                context,
                icon: Icons.menu_book_rounded,
                title: "Interview Preparation",
                subtitle:
                    "Prepare yourself with useful interview preparation materials.",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>  InterviewPreparationScreen(),
                    ),
                  );
                },
              ),
              _benefitItem(
                context,
                icon: Icons.record_voice_over_outlined,
                title: "Mock Interview Practice",
                subtitle:
                    "Practice your interview skills with mock interview questions.",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MockInterviewScreen(),
                    ),
                  );
                },
              ),

              _benefitItem(
                context,
                icon: Icons.question_answer_outlined,
                title: "Interview Questions & Answers",
                subtitle:
                    "Learn common interview questions and their answers.",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InterviewQuestionsAnswersScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

         

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // BENEFIT ITEM
  // ===============================================================

  Widget _benefitItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,

          child: Padding(
            padding: const EdgeInsets.all(15),

            child: Row(
              children: [

                // ---------------------------------------------------
                // ICON
                // ---------------------------------------------------

                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Design.buttonColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Icon(
                    icon,
                    color: Design.buttonColor,
                    size: 26,
                  ),
                ),

                const SizedBox(width: 14),

                // ---------------------------------------------------
                // TEXT
                // ---------------------------------------------------

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [

                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // ---------------------------------------------------
                // ARROW
                // ---------------------------------------------------

                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
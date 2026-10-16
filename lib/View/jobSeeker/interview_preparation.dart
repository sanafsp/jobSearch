import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_project/Constants/core/color.dart';

class InterviewPreparationScreen extends StatefulWidget {
  const InterviewPreparationScreen({super.key});

  @override
  State<InterviewPreparationScreen> createState() =>
      _InterviewPreparationScreenState();
}

class _InterviewPreparationScreenState
    extends State<InterviewPreparationScreen> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // FIRESTORE 

  Stream<QuerySnapshot<Map<String, dynamic>>> _preparationStream() {
    return _firestore
        .collection('interview_preparation')
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,

      appBar: AppBar(
        leading:IconButton(onPressed: (){Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios)) ,
        backgroundColor: Design.buttonColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Interview Preparation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _preparationStream(),

        builder: (context, snapshot) {

         
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

        

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red.shade300,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Unable to load interview preparation.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

        
          final documents = snapshot.data?.docs ?? [];

         
if (documents.isEmpty) {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        // _headerCard(),

        const SizedBox(height: 24),

        const Text(
          'Preparation Guide',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          'Follow these steps to prepare yourself for a successful interview.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),

        const SizedBox(height: 20),

        // No Firebase data
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 30,
            ),
            child: Column(
              children: [
                Icon(
                  Icons.menu_book_outlined,
                  size: 60,
                  color: Colors.grey.shade400,
                ),

                const SizedBox(height: 12),

                Text(
                  'No preparation content available yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        _interviewDayChecklist(),
      ],
    ),
  );
}
          // FIREBASE DATA
      

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

           

                const SizedBox(height: 24),

                // Section title
                const Text(
                  'Preparation Guide',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  'Follow these steps to prepare yourself for a successful interview.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 16),

              
                ...documents.asMap().entries.map(
                  (entry) {

                    final index = entry.key;
                    final data = entry.value.data();

                    final title =
                        data['title']?.toString() ?? '';

                    final description =
                        data['description']?.toString() ?? '';

                    return _preparationCard(
                      context,
                      number: index + 1,
                      title: title,
                      description: description,
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Interview checklist
                _interviewDayChecklist(),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }



  Widget _headerCard() {
    return Container(
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

      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Icon(
            Icons.menu_book_rounded,
            color: Colors.white,
            size: 42,
          ),

          SizedBox(height: 14),

          Text(
            'Get Interview Ready',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 8),

          Text(
            'Prepare your resume, improve your communication, practice common questions, and build confidence before your interview.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }



  Widget _preparationCard(
    BuildContext context, {
    required int number,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

       

          Container(
            width: 48,
            height: 48,

            decoration: BoxDecoration(
              color: Design.buttonColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),

            child: Icon(
              _getIcon(number),
              color: Design.buttonColor,
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

       

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Row(
                  children: [

                    // Number
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),

                      decoration: BoxDecoration(
                        color: Design.buttonColor,
                        borderRadius: BorderRadius.circular(6),
                      ),

                      child: Text(
                        '$number',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Title
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Description
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

 

  IconData _getIcon(int number) {
    switch (number) {
      case 1:
        return Icons.assignment_outlined;

      case 2:
        return Icons.business_outlined;

      case 3:
        return Icons.person_outline;

      case 4:
        return Icons.question_answer_outlined;

      case 5:
        return Icons.record_voice_over_outlined;

      case 6:
        return Icons.accessibility_new_outlined;

      case 7:
        return Icons.checkroom_outlined;

      case 8:
        return Icons.schedule_outlined;

      case 9:
        return Icons.lightbulb_outline;

      case 10:
        return Icons.self_improvement_outlined;

      default:
        return Icons.menu_book_outlined;
    }
  }



  Widget _interviewDayChecklist() {

    final items = [
      'Carry a copy of your resume.',
      'Keep your required certificates/documents ready.',
      'Check the interview location or meeting link.',
      'Keep your phone charged.',
      'Arrive a few minutes early.',
      'Listen carefully before answering.',
      'Thank the interviewer at the end.',
    ];

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: Design.buttonColor.withOpacity(0.15),
        ),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          const Text(
            'Interview Day Checklist',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Icon(
                    Icons.check_circle,
                    color: Design.buttonColor,
                    size: 20,
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
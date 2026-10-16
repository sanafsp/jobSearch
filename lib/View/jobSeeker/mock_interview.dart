import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:job_project/Constants/core/color.dart';

class MockInterviewScreen extends StatefulWidget {
  const MockInterviewScreen({super.key});

  @override
  State<MockInterviewScreen> createState() => _MockInterviewScreenState();
}

class _MockInterviewScreenState extends State<MockInterviewScreen> {
  // final List<Map<String, String>> questions =
  //  [
  //   {
  //     'question': 'Tell me about yourself.',
  //     'category': 'HR',
  //     'tip':
  //         'Keep your answer short. Mention your education, important skills, experience, and career goal.',
  //   },
  //   {
  //     'question': 'Why do you want to join our company?',
  //     'category': 'HR',
  //     'tip':
  //         'Show that you have researched the company and explain why the role matches your career goals.',
  //   },
  //   {
  //     'question': 'What are your strengths?',
  //     'category': 'HR',
  //     'tip':
  //         'Mention strengths that are relevant to the job and support them with a short example.',
  //   },
  //   {
  //     'question': 'What is one area you are working to improve?',
  //     'category': 'HR',
  //     'tip':
  //         'Choose a genuine improvement area and explain what you are doing to improve it.',
  //   },
  //   {
  //     'question': 'Why should we hire you?',
  //     'category': 'HR',
  //     'tip':
  //         'Connect your skills and experience with the requirements of the position.',
  //   },
  //   {
  //     'question': 'Where do you see yourself in five years?',
  //     'category': 'HR',
  //     'tip':
  //         'Talk about realistic professional growth, learning, and contribution to your field.',
  //   },
  //   {
  //     'question': 'Describe a difficult problem you solved.',
  //     'category': 'Situational',
  //     'tip':
  //         'Use the STAR approach: Situation, Task, Action, and Result.',
  //   },
  //   {
  //     'question': 'How do you handle working under pressure?',
  //     'category': 'Situational',
  //     'tip':
  //         'Explain how you prioritize tasks, stay organized, and communicate when necessary.',
  //   },
  //   {
  //     'question': 'Do you prefer working independently or in a team?',
  //     'category': 'Situational',
  //     'tip':
  //         'Show flexibility and explain that your approach depends on the task.',
  //   },
  //   {
  //     'question': 'Do you have any questions for us?',
  //     'category': 'HR',
  //     'tip':
  //         'Ask about the role, team, responsibilities, training, or expectations.',
  //   },
  // ];

 
 final List<Map<String, String>> questions =[];
  int currentQuestion = 0;
  int answeredQuestions = 0;
  bool showTip = false;
  bool isFetchingQuestions=true;

  final TextEditingController answerController = TextEditingController();

   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
   String _searchQuery = "";
   bool hasData=false;
  @override
  void initState() {
   fetchMockInterviewQuestions();
    super.initState();
  }

    var question;
 
    double  progress = 0.0;

Future<void> fetchMockInterviewQuestions() async {
  
  
  try {

    Query query = _firestore
        .collection('mock_interview')
        .orderBy('createdAt');

    QuerySnapshot snapshot = await query.get();

    if (snapshot.docs.isEmpty) {
      setState(() {
        hasData = false;
        isFetchingQuestions = false;
      });
      return;
    }
    // Clear old questions if needed
    // questions.clear();

    for (var a in snapshot.docs) {
      print('f');
      // Convert Firestore data to Map<String, dynamic>
      final data = a.data() as Map<String, dynamic>;

      Map<String, String> mp = {
        'question': data['question']?.toString() ?? '',
        'category': data['category']?.toString() ?? '',
        'tip': data['tip']?.toString() ?? '',
      };

      questions.add(mp);
    }

// print('g');

 question  = questions[currentQuestion];
    // progress= (currentQuestion + 1) / questions.length;
    setState(() {
      hasData = questions.isNotEmpty;
      isFetchingQuestions = false;
    });

  } catch (e) {


    setState(() {
      isFetchingQuestions = false;
      hasData = false;
    });

  }}



  @override
  void dispose() {
    answerController.dispose();
    super.dispose();
  }

  void _nextQuestion() {
   
    if (answerController.text.trim().isNotEmpty) {
      answeredQuestions++;
    }

    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        answerController.clear();
        showTip = false;
          progress=(answeredQuestions / questions.length);
      });
    } else {
        progress=(answeredQuestions / questions.length);
        setState(() {
          
        });
      _showResult();
    }
    print('progress is $progress');
  }

  void _previousQuestion() {
    if (currentQuestion > 0) {
      setState(() {
        currentQuestion--;
        answerController.clear();
        showTip = false;
      });
    }
  }

  void _showResult() {
    final percentage =
        ((answeredQuestions / questions.length) * 100).round();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Mock Interview Completed',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events_outlined,
                size: 65,
                color: Colors.orange,
              ),
              const SizedBox(height: 15),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Design.buttonColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '$answeredQuestions of ${questions.length} questions answered',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Keep practicing to improve your interview confidence.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  currentQuestion = 0;
                  answeredQuestions = 0;
                  answerController.clear();
                  showTip = false;
                });
              },
              child: const Text('Practice Again'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Design.buttonColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Finish'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
  
  Size size=MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
         leading:IconButton(onPressed: (){Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios)) ,
        backgroundColor: Design.buttonColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Mock Interview',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isFetchingQuestions?SizedBox():
            _progressSection(progress),

            const SizedBox(height: 22),
            
            isFetchingQuestions?
            SizedBox(
              height: size.height*.75,
              child: Center(child: CircularProgressIndicator()))
            :isFetchingQuestions==false&& hasData==false?
            Text('No Data'):

            Column(
              children: [
               Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Design.buttonColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    question['category']!,
                    style: TextStyle(
                      color: Design.buttonColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${currentQuestion + 1}/${questions.length}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Interview Question',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    question['question']!,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Your Answer',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: answerController,
              maxLines: 7,
              decoration: InputDecoration(
                hintText: 'Type your answer here...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Colors.grey.shade200,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: Design.buttonColor,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 14),

            InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                setState(() {
                  showTip = !showTip;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Design.buttonColor.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Design.buttonColor,
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Need a tip?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(
                          showTip
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Design.buttonColor,
                        ),
                      ],
                    ),
                    if (showTip) ...[
                      const SizedBox(height: 10),
                      Text(
                        question['tip']!,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            Row(
              children: [
                if (currentQuestion > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousQuestion,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 52),
                        side: BorderSide(
                          color: Design.buttonColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Previous',
                        style: TextStyle(
                          color: Design.buttonColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (currentQuestion > 0) const SizedBox(width: 12),
                Expanded(
                  flex: currentQuestion > 0 ? 1 : 1,
                  child: ElevatedButton(
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Design.buttonColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      currentQuestion == questions.length - 1
                          ? 'Finish Interview'
                          : 'Next Question',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),
              ],
            )

            
          ],
        ),
      ),
    );
  }

  Widget _progressSection(double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'Interview Progress',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '${(progress * 100).round()}%',
                style: TextStyle(
                  color: Design.buttonColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                Design.buttonColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
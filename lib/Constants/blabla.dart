// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:job_project/Constants/core/color.dart';

// class InterviewContentAdminScreen extends StatelessWidget {
//   final String collection;
//   final String title;

//   const InterviewContentAdminScreen({
//     super.key,
//     required this.collection,
//     required this.title,
//   });

//   bool get isPreparation =>
//       collection == 'interview_preparation';

//   bool get isMockInterview =>
//       collection == 'mock_interview';

//   bool get isQuestionsAnswers =>
//       collection == 'interview_questions_answers';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         backgroundColor: Design.buttonColor,
//         foregroundColor: Colors.white,
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),

//       floatingActionButton: FloatingActionButton.extended(
//         backgroundColor: Design.buttonColor,
//         foregroundColor: Colors.white,
//         onPressed: () {
//           _showAddDialog(context);
//         },
//         icon: const Icon(Icons.add),
//         label: const Text('Add Content'),
//       ),

//       body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         stream: FirebaseFirestore.instance
//             .collection(collection)
//             .orderBy(
//               'createdAt',
//               descending: true,
//             )
//             .snapshots(),

//         builder: (context, snapshot) {
//           if (snapshot.connectionState ==
//               ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           if (snapshot.hasError) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Text(
//                   'Error loading content:\n${snapshot.error}',
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             );
//           }

//           final documents = snapshot.data?.docs ?? [];

//           if (documents.isEmpty) {
//             return _emptyState(context);
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.fromLTRB(
//               16,
//               16,
//               16,
//               100,
//             ),
//             itemCount: documents.length,
//             itemBuilder: (context, index) {
//               final doc = documents[index];

//               return _contentCard(
//                 context,
//                 doc,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   Widget _contentCard(
//     BuildContext context,
//     QueryDocumentSnapshot<Map<String, dynamic>> doc,
//   ) {
//     final data = doc.data();

//     String heading = '';
//     String subtitle = '';
//     String category = '';

//     if (isPreparation) {
//       heading = data['title'] ?? '';
//       subtitle = data['description'] ?? '';
//     } else {
//       heading = data['question'] ?? '';
//       category = data['category'] ?? '';

//       if (isMockInterview) {
//         subtitle = data['tip'] ?? '';
//       } else {
//         subtitle = data['answer'] ?? '';
//       }
//     }

//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(17),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 7,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           crossAxisAlignment:
//               CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color:
//                         Design.buttonColor.withOpacity(0.10),
//                     borderRadius:
//                         BorderRadius.circular(12),
//                   ),
//                   child: Icon(
//                     isPreparation
//                         ? Icons.menu_book_rounded
//                         : isMockInterview
//                             ? Icons
//                                 .record_voice_over_outlined
//                             : Icons
//                                 .question_answer_outlined,
//                     color: Design.buttonColor,
//                   ),
//                 ),

//                 const SizedBox(width: 12),

//                 Expanded(
//                   child: Text(
//                     heading,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),

//                 PopupMenuButton<String>(
//                   onSelected: (value) {
//                     if (value == 'edit') {
//                       _showEditDialog(
//                         context,
//                         doc,
//                       );
//                     }

//                     if (value == 'delete') {
//                       _deleteContent(
//                         context,
//                         doc.id,
//                       );
//                     }
//                   },
//                   itemBuilder: (_) => const [
//                     PopupMenuItem(
//                       value: 'edit',
//                       child: Row(
//                         children: [
//                           Icon(Icons.edit_outlined),
//                           SizedBox(width: 10),
//                           Text('Edit'),
//                         ],
//                       ),
//                     ),
//                     PopupMenuItem(
//                       value: 'delete',
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.delete_outline,
//                             color: Colors.red,
//                           ),
//                           SizedBox(width: 10),
//                           Text('Delete'),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),

//             if (category.isNotEmpty) ...[
//               const SizedBox(height: 10),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 9,
//                   vertical: 5,
//                 ),
//                 decoration: BoxDecoration(
//                   color:
//                       Design.buttonColor.withOpacity(0.08),
//                   borderRadius:
//                       BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   category,
//                   style: TextStyle(
//                     color: Design.buttonColor,
//                     fontSize: 11,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],

//             const SizedBox(height: 10),

//             Text(
//               subtitle,
//               maxLines: 3,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 color: Colors.grey.shade700,
//                 fontSize: 13,
//                 height: 1.5,
//               ),
//             ),

//             if (isQuestionsAnswers) ...[
//               const SizedBox(height: 10),
//               Text(
//                 'Tip: ${data['tip'] ?? ''}',
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   color: Colors.grey.shade500,
//                   fontSize: 12,
//                   height: 1.4,
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _emptyState(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           mainAxisAlignment:
//               MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.library_books_outlined,
//               size: 70,
//               color: Colors.grey.shade400,
//             ),
//             const SizedBox(height: 15),
//             const Text(
//               'No Content Added',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Tap "Add Content" to create your first item.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showAddDialog(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => AddInterviewContentScreen(
//           collection: collection,
//           title: title,
//         ),
//       ),
//     );
//   }

//   void _showEditDialog(
//     BuildContext context,
//     QueryDocumentSnapshot<Map<String, dynamic>> doc,
//   ) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => AddInterviewContentScreen(
//           collection: collection,
//           title: title,
//           documentId: doc.id,
//           existingData: doc.data(),
//         ),
//       ),
//     );
//   }

//   Future<void> _deleteContent(
//     BuildContext context,
//     String documentId,
//   ) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Delete Content?'),
//           content: const Text(
//             'Are you sure you want to delete this content?',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context, false);
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//               ),
//               onPressed: () {
//                 Navigator.pop(context, true);
//               },
//               child: const Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );

//     if (confirm != true) return;

//     try {
//       await FirebaseFirestore.instance
//           .collection(collection)
//           .doc(documentId)
//           .delete();

//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Content deleted successfully'),
//           ),
//         );
//       }
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Delete failed: $e'),
//           ),
//         );
//       }
//     }
//   }
// }

// class AddInterviewContentScreen extends StatefulWidget {
//   final String collection;
//   final String title;

//   final String? documentId;
//   final Map<String, dynamic>? existingData;

//   const AddInterviewContentScreen({
//     super.key,
//     required this.collection,
//     required this.title,
//     this.documentId,
//     this.existingData,
//   });

//   @override
//   State<AddInterviewContentScreen> createState() =>
//       _AddInterviewContentScreenState();
// }

// class _AddInterviewContentScreenState
//     extends State<AddInterviewContentScreen> {
//   final titleController = TextEditingController();
//   final descriptionController = TextEditingController();

//   final questionController = TextEditingController();
//   final categoryController = TextEditingController();
//   final answerController = TextEditingController();
//   final tipController = TextEditingController();

//   bool isSaving = false;

//   bool get isEditing => widget.documentId != null;

//   bool get isPreparation =>
//       widget.collection == 'interview_preparation';

//   bool get isMockInterview =>
//       widget.collection == 'mock_interview';

//   bool get isQuestionsAnswers =>
//       widget.collection == 'interview_questions_answers';

//   @override
//   void initState() {
//     super.initState();

//     final data = widget.existingData;

//     if (data != null) {
//       titleController.text =
//           data['title']?.toString() ?? '';

//       descriptionController.text =
//           data['description']?.toString() ?? '';

//       questionController.text =
//           data['question']?.toString() ?? '';

//       categoryController.text =
//           data['category']?.toString() ?? '';

//       answerController.text =
//           data['answer']?.toString() ?? '';

//       tipController.text =
//           data['tip']?.toString() ?? '';
//     }
//   }

//   @override
//   void dispose() {
//     titleController.dispose();
//     descriptionController.dispose();
//     questionController.dispose();
//     categoryController.dispose();
//     answerController.dispose();
//     tipController.dispose();
//     super.dispose();
//   }

//   Future<void> _saveContent() async {
//     if (isPreparation) {
//       if (titleController.text.trim().isEmpty ||
//           descriptionController.text.trim().isEmpty) {
//         _showMessage('Please enter title and description.');
//         return;
//       }
//     } else {
//       if (questionController.text.trim().isEmpty ||
//           categoryController.text.trim().isEmpty) {
//         _showMessage(
//           'Please enter question and category.',
//         );
//         return;
//       }

//       if (isQuestionsAnswers &&
//           answerController.text.trim().isEmpty) {
//         _showMessage('Please enter the answer.');
//         return;
//       }
//     }

//     setState(() {
//       isSaving = true;
//     });

//     try {
//       final firestore = FirebaseFirestore.instance;

//       Map<String, dynamic> data = {};

//       if (isPreparation) {
//         data = {
//           'title': titleController.text.trim(),
//           'description':
//               descriptionController.text.trim(),
//           'updatedAt': FieldValue.serverTimestamp(),
//         };
//       } else if (isMockInterview) {
//         data = {
//           'question': questionController.text.trim(),
//           'category': categoryController.text.trim(),
//           'tip': tipController.text.trim(),
//           'updatedAt': FieldValue.serverTimestamp(),
//         };
//       } else if (isQuestionsAnswers) {
//         data = {
//           'question': questionController.text.trim(),
//           'category': categoryController.text.trim(),
//           'answer': answerController.text.trim(),
//           'tip': tipController.text.trim(),
//           'updatedAt': FieldValue.serverTimestamp(),
//         };
//       }

//       if (isEditing) {
//         await firestore
//             .collection(widget.collection)
//             .doc(widget.documentId)
//             .update(data);
//       } else {
//         data['createdAt'] =
//             FieldValue.serverTimestamp();

//         await firestore
//             .collection(widget.collection)
//             .add(data);
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               isEditing
//                   ? 'Content updated successfully'
//                   : 'Content added successfully',
//             ),
//           ),
//         );

//         Navigator.pop(context);
//       }
//     } catch (e) {
//       _showMessage(
//         'Something went wrong: $e',
//       );
//     } finally {
//       if (mounted) {
//         setState(() {
//           isSaving = false;
//         });
//       }
//     }
//   }

//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         backgroundColor: Design.buttonColor,
//         foregroundColor: Colors.white,
//         title: Text(
//           isEditing
//               ? 'Edit ${widget.title}'
//               : 'Add ${widget.title}',
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment:
//               CrossAxisAlignment.start,
//           children: [
//             if (isPreparation)
//               _buildPreparationForm()
//             else if (isMockInterview)
//               _buildMockInterviewForm()
//             else
//               _buildQuestionsAnswersForm(),

//             const SizedBox(height: 25),

//             SizedBox(
//               width: double.infinity,
//               height: 52,
//               child: ElevatedButton(
//                 onPressed:
//                     isSaving ? null : _saveContent,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Design.buttonColor,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius:
//                         BorderRadius.circular(14),
//                   ),
//                 ),
//                 child: isSaving
//                     ? const SizedBox(
//                         height: 23,
//                         width: 23,
//                         child:
//                             CircularProgressIndicator(
//                           color: Colors.white,
//                           strokeWidth: 2,
//                         ),
//                       )
//                     : Text(
//                         isEditing
//                             ? 'Update Content'
//                             : 'Save Content',
//                         style: const TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 15,
//                         ),
//                       ),
//               ),
//             ),

//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPreparationForm() {
//     return Column(
//       crossAxisAlignment:
//           CrossAxisAlignment.start,
//       children: [
//         _sectionTitle(
//           'Preparation Topic',
//         ),

//         const SizedBox(height: 12),

//         _textField(
//           controller: titleController,
//           label: 'Title',
//           hint: 'Example: Prepare Your Resume',
//           icon: Icons.title,
//         ),

//         const SizedBox(height: 15),

//         _textField(
//           controller: descriptionController,
//           label: 'Description',
//           hint:
//               'Enter the preparation content...',
//           icon: Icons.description_outlined,
//           maxLines: 7,
//         ),
//       ],
//     );
//   }

//   Widget _buildMockInterviewForm() {
//     return Column(
//       crossAxisAlignment:
//           CrossAxisAlignment.start,
//       children: [
//         _sectionTitle(
//           'Mock Interview Question',
//         ),

//         const SizedBox(height: 12),

//         _textField(
//           controller: categoryController,
//           label: 'Category',
//           hint: 'Example: HR',
//           icon: Icons.category_outlined,
//         ),

//         const SizedBox(height: 15),

//         _textField(
//           controller: questionController,
//           label: 'Question',
//           hint:
//               'Example: Tell me about yourself.',
//           icon: Icons.question_mark_outlined,
//           maxLines: 4,
//         ),

//         const SizedBox(height: 15),

//         _textField(
//           controller: tipController,
//           label: 'Interview Tip',
//           hint:
//               'Enter a helpful tip for answering...',
//           icon: Icons.lightbulb_outline,
//           maxLines: 6,
//         ),
//       ],
//     );
//   }

//   // Widget _buildQuestionsAnswersForm() {
//   //   return Column(
//   //     crossAxisAlignment:
//   //         CrossAxisAlignment.start,
//   //     children: [
//   //       _sectionTitle(
//   //         'Interview Question & Answer',
//   //       ),

//   //       const SizedBox(height: 12),

//   //       _textField(
//   //         controller: categoryController,
//   //         label: 'Category',
//   //         hint:
//   //             'Example: HR / Technical / Flutter / Fresher',
//   //         icon: Icons.category_outlined,
//   //       ),

//   //       const SizedBox(height: 15),

//   //       _textField(
//   //         controller: questionController,
//   //         label: 'Question',
//   //         hint:
//   //             'Example: What is Flutter?',
//   //         icon: Icons.question_mark_outlined,
//   //         maxLines: 4,
//   //       ),

//   //       const SizedBox(height: 15),

//   //       _textField(
//   //         controller: answerController,
//   //         label: 'Answer',
//   //         hint:
//   //             'Enter the suggested answer...',
//   //         icon: Icons.check_circle_outline,
//   //         maxLines: 8,
//   //       ),

//   //       const SizedBox(height: 15),

//   //       _textField(
//   //         controller: tipController,
//   //         label: 'Interview Tip',
//   //         hint:
//   //             'Enter an interview tip...',
//   //         icon: Icons.lightbulb_outline,
//   //         maxLines: 6,
//   //       ),
//   //     ],
//   //   );
//   // }

//   // Widget _sectionTitle(String text) {
//   //   return Text(
//   //     text,
//   //     style: const TextStyle(
//   //       fontSize: 20,
//   //       fontWeight: FontWeight.bold,
//   //     ),
//   //   );
//   // }

//   // Widget _textField({
//   //   required TextEditingController controller,
//   //   required String label,
//   //   required String hint,
//   //   required IconData icon,
//   //   int maxLines = 1,
//   // }) {
//   //   return TextField(
//   //     controller: controller,
//   //     maxLines: maxLines,
//   //     decoration: InputDecoration(
//   //       labelText: label,
//   //       hintText: hint,
//   //       prefixIcon: Padding(
//   //         padding: EdgeInsets.only(
//   //           bottom: maxLines > 1 ? 0 : 0,
//   //         ),
//   //         child: Icon(icon),
//   //       ),
//   //       alignLabelWithHint: maxLines > 1,
//   //       filled: true,
//   //       fillColor: Colors.white,
//   //       border: OutlineInputBorder(
//   //         borderRadius:
//   //             BorderRadius.circular(14),
//   //         borderSide: BorderSide.none,
//   //       ),
//   //       enabledBorder: OutlineInputBorder(
//   //         borderRadius:
//   //             BorderRadius.circular(14),
//   //         borderSide: BorderSide(
//   //           color: Colors.grey.shade200,
//   //         ),
//   //       ),
//   //       focusedBorder: OutlineInputBorder(
//   //         borderRadius:
//   //             BorderRadius.circular(14),
//   //         borderSide: BorderSide(
//   //           color: Design.buttonColor,
//   //           width: 1.5,
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }

// }
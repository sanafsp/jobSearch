import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/Controller/admin_controller.dart';
import 'package:job_project/View/admin/addinterviewContentScreen.dart';

class InterviewContentAdminScreen extends StatelessWidget {
   String collection;
   String title;
  final AdminController adminController = AdminController();


   InterviewContentAdminScreen({
    super.key,
    required this.collection,
    required this.title,
  });
  

  bool get isPreparation =>
      collection == 'interview_preparation';

  bool get isMockInterview =>
      collection == 'mock_interview';

  bool get isQuestionsAnswers =>
      collection == 'interview_questions_answers';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Design.buttonColor,
        foregroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection(collection)
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Error loading content:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final documents = snapshot.data?.docs ?? [];

          if (documents.isEmpty) {
            return _emptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              100,
            ),
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];

              return _contentCard(
                context,
                doc,
              );
            },
          );
        },
      ),

       floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Design.buttonColor,
        foregroundColor: Colors.white,
        onPressed: () {
           adminController.setTitleAndCollection(tItle: title, cOllection: collection);

           
          //  adminController.showAddDialog(context );

           Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddInterviewContentScreen(
          collection: collection,
          title: title,
        ),
      ),
    );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Content'),
      ),

     
    );
  }

  Widget _contentCard(
    BuildContext context,
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    String heading = '';
    String subtitle = '';
    String category = '';

    if (isPreparation) {
      heading = data['title'] ?? '';
      subtitle = data['description'] ?? '';
    } else {
      heading = data['question'] ?? '';
      category = data['category'] ?? '';

      if (isMockInterview) {
        subtitle = data['tip'] ?? '';
      } else {
        subtitle = data['answer'] ?? '';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 7,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color:
                        Design.buttonColor.withOpacity(0.10),
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isPreparation
                        ? Icons.menu_book_rounded
                        : isMockInterview
                            ? Icons
                                .record_voice_over_outlined
                            : Icons
                                .question_answer_outlined,
                    color: Design.buttonColor,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    heading,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                     adminController.showEditDialog(
        context,
        doc,
      );
                    }

                    if (value == 'delete') {
                        adminController.deleteContent(
        context,
        doc.id,
      );
                      // _deleteContent(
                      //   context,
                      //   doc.id,
                      // );
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined),
                          SizedBox(width: 10),
                          Text('Edit'),
                        ],
                      ),
                    ),

                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          SizedBox(width: 10),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            if (category.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color:
                      Design.buttonColor.withOpacity(0.08),
                  borderRadius:
                      BorderRadius.circular(20),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: Design.buttonColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 10),

            Text(
              subtitle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
                height: 1.5,
              ),
            ),

            if (isQuestionsAnswers) ...[
              const SizedBox(height: 10),
              Text(
                'Tip: ${data['tip'] ?? ''}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_books_outlined,
              size: 70,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 15),
            const Text(
              'No Content Added',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "Add Content" to create your first item.',
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

}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_project/View/admin/addinterviewContentScreen.dart';


class AdminController extends ChangeNotifier{
  String collection='';
   String title='';
   AdminController(
    //  collection??'interview_preparation', // collection: 'interview_preparation',
    // required this.title,
  );

  void setTitleAndCollection({required String tItle, required String cOllection}){
  collection=cOllection;
  title=tItle;

   }


  void showAddDialog(BuildContext context) {
    print('click comes here in a');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddInterviewContentScreen(
          collection: collection,
          title: title,
        ),
      ),
    );
  }
  
  void showEditDialog(
    BuildContext context,
    QueryDocumentSnapshot<Map<String, dynamic>> doc) {

    print('click comes here in b');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddInterviewContentScreen(   
          collection: collection,
          title: title,
          documentId: doc.id,
          existingData: doc.data(),
        ),
      ),
    );
  }

  
  Future<void> deleteContent(
    BuildContext context,
    String documentId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Content?'),
          content: const Text(
            'Are you sure you want to delete this content?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(documentId)
          .delete();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Content deleted successfully'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Delete failed: $e'),
          ),
        );
      }
    }
  }

  InterviewTopicModel interviewTopicModel=InterviewTopicModel();

  InterviewQuestionModel interviewQuestionModel=InterviewQuestionModel();

}


class InterviewTopicModel{
  String? title;
  String?description;

  InterviewTopicModel({
    this.title,this.description});

  
}


class InterviewQuestionModel{
  String? category;
  String?quesiton;
  String?answer;
  String?interviewTip;

  InterviewQuestionModel({
    this.category,this.quesiton,
    this.answer,this.interviewTip });

  
}
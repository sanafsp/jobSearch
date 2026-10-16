
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/Constants/enums.dart';
import 'package:job_project/Controller/admin_controller.dart';
import 'package:job_project/Widget/admin_page.dart';
import 'package:provider/provider.dart';

class AddInterviewContentScreen extends StatefulWidget {
  final String collection;
  final String title;

  final String? documentId;
  final Map<String, dynamic>? existingData;

  const AddInterviewContentScreen({
    super.key,
    required this.collection,
    required this.title,
    this.documentId,
    this.existingData,
  });

  @override
  State<AddInterviewContentScreen> createState() =>
      _AddInterviewContentScreenState();
}

class _AddInterviewContentScreenState
    extends State<AddInterviewContentScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final questionController = TextEditingController();
  final categoryController = TextEditingController();
  final answerController = TextEditingController();
  final tipController = TextEditingController();

  bool isSaving = false;

  bool get isEditing => widget.documentId != null;

  bool get isPreparation =>
      widget.collection == 'interview_preparation';

  bool get isMockInterview =>
      widget.collection == 'mock_interview';

  bool get isQuestionsAnswers =>
      widget.collection == 'interview_questions_answers';

  @override
  void initState() {
    super.initState();

    final data = widget.existingData;

    if (data != null) {
      titleController.text =
          data['title']?.toString() ?? '';

      descriptionController.text =
          data['description']?.toString() ?? '';

      questionController.text =
          data['question']?.toString() ?? '';

      categoryController.text =
          data['category']?.toString() ?? '';

      answerController.text =
          data['answer']?.toString() ?? '';

      tipController.text =
          data['tip']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    questionController.dispose();
    categoryController.dispose();
    answerController.dispose();
    tipController.dispose();
    super.dispose();
  }

  Future<void> _saveContent() async {
    if (isPreparation) {
      if (titleController.text.trim().isEmpty ||
          descriptionController.text.trim().isEmpty) {
        _showMessage('Please enter title and description.');
        return;
      }
    } else {
      if (questionController.text.trim().isEmpty ||
          categoryController.text.trim().isEmpty) {
        _showMessage(
          'Please enter question and category.',
        );
        return;
      }

      if (isQuestionsAnswers &&
          answerController.text.trim().isEmpty) {
        _showMessage('Please enter the answer.');
        return;
      }
    }

    setState(() {
      isSaving = true;
    });

    try {
      final firestore = FirebaseFirestore.instance;

      Map<String, dynamic> data = {};

      if (isPreparation) {
        data = {
          'title': titleController.text.trim(),
          'description':
              descriptionController.text.trim(),
          'updatedAt': FieldValue.serverTimestamp(),
        };
      } else if (isMockInterview) {
        data = {
          'question': questionController.text.trim(),
          'category': categoryController.text.trim(),
          'tip': tipController.text.trim(),
          'updatedAt': FieldValue.serverTimestamp(),
        };
      } else if (isQuestionsAnswers) {
        data = {
          'question': questionController.text.trim(),
          'category': categoryController.text.trim(),
          'answer': answerController.text.trim(),
          'tip': tipController.text.trim(),
          'updatedAt': FieldValue.serverTimestamp(),
        };
      }

      if (isEditing) {
        await firestore
            .collection(widget.collection)
            .doc(widget.documentId)
            .update(data);
      } else {
        data['createdAt'] =
            FieldValue.serverTimestamp();

        await firestore
            .collection(widget.collection)
            .add(data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing
                  ? 'Content updated successfully'
                  : 'Content added successfully',
            ),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      _showMessage(
        'Something went wrong: $e',
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('widget.collection is ${widget.collection}');
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Design.buttonColor,
        foregroundColor: Colors.white,
        title: Text(
          isEditing
              ? 'Edit ${widget.title}'
              : 'Add ${widget.title}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            if (isPreparation)
              // PreparationForm()
              preparationWidget()
            else if (isMockInterview)
             mockInterviewWidget()
              // MockInterviewForm()
            else
              // QuestionsAnswersForm(),
              questionAswersWidget(),
            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed:
                    isSaving ? null : _saveContent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Design.buttonColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
                child: isSaving
                    ? const SizedBox(
                        height: 23,
                        width: 23,
                        child:
                            CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        isEditing
                            ? 'Update Content'
                            : 'Save Content',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }


  Widget preparationWidget(){
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        sectionTitle(
          'Preparation Topic',
        ),

        const SizedBox(height: 12),

        Utilitywidgets.textField(
          controller: titleController,
          label: 'Title',
          hint: 'Example: Prepare Your Resume',
          icon: Icons.title,
          adminScreenType: AdminScreenType.interviewPrep,
          
        ),

        const SizedBox(height: 15),

       Utilitywidgets.textField(
          controller: descriptionController,
          label: 'Description',
          hint:
              'Enter the preparation content...',
          icon: Icons.description_outlined,
          maxLines: 7,
           adminScreenType: AdminScreenType.interviewPrep,
        ),
      ],
    );
  }

  Widget mockInterviewWidget(){
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        sectionTitle(
          'Mock Interview Question',
        ),

        const SizedBox(height: 12),

        Utilitywidgets.textField(
          controller: categoryController,
          label: 'Category',
          hint: 'Example: HR',
          icon: Icons.category_outlined,
          adminScreenType: AdminScreenType.mockInterview
        ),

        const SizedBox(height: 15),

        Utilitywidgets.textField(
          controller: questionController,
          label: 'Question',
          hint:
              'Example: Tell me about yourself.',
          icon: Icons.question_mark_outlined,
          maxLines: 4,
           adminScreenType: AdminScreenType.mockInterview
        ),

        const SizedBox(height: 15),

        Utilitywidgets.textField(
          controller: tipController,
          label: 'Interview Tip',
          hint:
              'Enter a helpful tip for answering...',
          icon: Icons.lightbulb_outline,
          maxLines: 6,
           adminScreenType: AdminScreenType.mockInterview
        ),
      ],
    );
  }

  Widget questionAswersWidget(){
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        sectionTitle(
          'Interview Question & Answer',
        ),

        const SizedBox(height: 12),

        Utilitywidgets.textField(
          controller: categoryController,
          label: 'Category',
          hint:
              'Example: HR / Technical / Flutter / Fresher',
          icon: Icons.category_outlined,
            adminScreenType: AdminScreenType.qAdA
          
        ),

        const SizedBox(height: 15),

        Utilitywidgets.textField(
          controller: questionController,
          label: 'Question',
          hint:
              'Example: What is Flutter?',
          icon: Icons.question_mark_outlined,
          maxLines: 4,
           adminScreenType: AdminScreenType.qAdA
        ),

        const SizedBox(height: 15),

        Utilitywidgets.textField(
          controller: answerController,
          label: 'Answer',
          hint:
              'Enter the suggested answer...',
          icon: Icons.check_circle_outline,
          maxLines: 8,
           adminScreenType: AdminScreenType.qAdA
        ),

        const SizedBox(height: 15),

        Utilitywidgets.textField(
          controller: tipController,
          label: 'Interview Tip',
          hint:
              'Enter an interview tip...',
          icon: Icons.lightbulb_outline,
          maxLines: 6,
           adminScreenType: AdminScreenType.qAdA
        ),
      ],
    );
  }

}

class Utilitywidgets{

  Utilitywidgets._();

sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  
  static textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required AdminScreenType adminScreenType,

    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      onChanged: (v){

        switch(adminScreenType){
          case AdminScreenType.interviewPrep:
            if(label=='Title'){
              
            }else{
             
            }
          break;
            // TODO: Handle this case.
          case AdminScreenType.mockInterview:
            // TODO: Handle this case.
          case AdminScreenType.qAdA:
            // TODO: Handle this case.
        }

      },
      maxLines: maxLines,
        textInputAction:
          maxLines > 1 ? TextInputAction.newline : TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            bottom: maxLines > 1 ? 0 : 0,
          ),
          child: Icon(icon),
        ),
        alignLabelWithHint: maxLines > 1,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Design.buttonColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }




}




 import 'package:flutter/material.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/Constants/enums.dart';
import 'package:job_project/Controller/admin_controller.dart';
import 'package:provider/provider.dart';

 sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  
  textField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required AdminScreenType adminScreenType,
    required AdminController adminController,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      onChanged: (v){

        switch(adminScreenType){
          case AdminScreenType.interviewPrep:
            if(label=='Title'){
              
             adminController.interviewTopicModel.title=v;
            
            }else{
             adminController.interviewTopicModel.description=v;
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

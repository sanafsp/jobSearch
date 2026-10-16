// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:job_project/Constants/app_styles.dart';
import 'package:job_project/Constants/core/color.dart';

text1(controler,data) {
  return 

 TextFormField(
              controller: controler,
              //  style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
              // keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                
                 filled: true,
                 fillColor: Design.bottom,
                labelText: data, contentPadding: const EdgeInsets.symmetric(horizontal: 14,vertical: 8),
                focusedBorder: AppStyles.textFieldFocusedBorder,
                         enabledBorder: AppStyles.textFieldEnabledBorder,
                                // focusedBorder: OutlineInputBorder(
                                //   borderSide:  BorderSide(color: Design.heading),
                                //   borderRadius:  BorderRadius.circular(10),
                                // ),
                                // enabledBorder: UnderlineInputBorder(
                                //   borderSide: new BorderSide(color: Colors.white),
                                //   borderRadius: new BorderRadius.circular(15),
                                // ),
                                ),
            );    }
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:job_project/const/core/color.dart';

text1(controler,data) {
  return 

 TextFormField(
              controller: controler,
              // keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                
                 filled: true,
                 fillColor: Design.bottom,
                labelText: data, contentPadding: const EdgeInsets.symmetric(horizontal: 14,vertical: 8),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:  BorderSide(color: Design.heading),
                                  borderRadius:  BorderRadius.circular(10),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.white),
                                  borderRadius: new BorderRadius.circular(15),
                                ),),
            );    }
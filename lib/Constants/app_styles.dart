import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/color.dart';

class AppStyles {
  AppStyles._();

  static TextStyle authGreetingTextStyle= const TextStyle(
                            color: Design.baseColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          );


  static TextStyle appBarTitleStyle=TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18
          );                      

  static TextStyle errorTextStyle=TextStyle(color: Colors.red.shade800);


  static TextStyle authQuestionQuoteStyle= const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          );

  static TextStyle submitBtnTextStyle= const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            );                        





//  textfield borders
  static OutlineInputBorder textFieldFocusedBorder= OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.blue,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(10),
            );

       
  static OutlineInputBorder textFieldEnabledBorder=OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(10),
            );

  static const SystemUiOverlayStyle appStatusBarStyle = SystemUiOverlayStyle(
  statusBarColor: Design.buttonColor,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light,
);          

}
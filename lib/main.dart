// MAIN PAGE (main.dart)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:job_project/Controller/auth_controller.dart';
import 'package:job_project/Controller/payment_controller.dart';
import 'package:job_project/View/Landing/landing.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/View/home/darkmode/themeProvider.dart';  
import 'package:job_project/View/login/signin.dart';

import 'package:job_project/widget/ui.dart';
import 'package:provider/provider.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: Design.buttonColor,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        ChangeNotifierProvider<AuthController>(
          create: (_) => AuthController(),
        ),

        ChangeNotifierProvider<PaymentController>(
          create: (_) => PaymentController()..initialize(),
        ),
    


      ],child:
    MyApp()));
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       themeMode: themeProvider.themeMode,
         theme: ThemeData(
        // brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
       
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: Landing(), //LoginPage 
    );
    
  }
  
}



// workers@gmail.com -worker123
// user123@gmail.com -user123
//abccompany@gmail.com -abc123
//xyzcompany@gmail.com -xyzxyz
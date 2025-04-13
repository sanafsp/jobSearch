// MAIN PAGE (main.dart)
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:job_project/home/darkmode/themeProvider.dart';  
import 'package:job_project/login/signin.dart';
import 'package:job_project/login/login.dart';
import 'package:job_project/widget/ui.dart';
import 'package:provider/provider.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
      home: LoginPage  (), 
    );
  }
}

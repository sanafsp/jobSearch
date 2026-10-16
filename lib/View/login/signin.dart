import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:job_project/Model/logged_user_model.dart';
import 'package:job_project/Repository/local_storage.dart';
import 'package:job_project/Constants/core/color.dart';
import 'package:job_project/View/admin/admin_home.dart';
// import 'package:job_project/View/admin/interview_content.dart';
import 'package:job_project/View/login/forgotpass.dart';
import 'package:job_project/widget/companyBottom.dart';
import 'package:job_project/widget/workersbottom.dart';
import '../../Constants/app_styles.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

    final String adminEmail = "admin123@gmail.com";
  final String adminPassword = "admin123";
  
  bool isLoadingLogin = false;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Design.buttonColor,
        statusBarIconBrightness: Brightness.light);
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: Design.baseColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Center(
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 200,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(
                          // bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Welcome back!\nSign in to continue",
                          textAlign: TextAlign.center,
                          style: AppStyles.authGreetingTextStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: .1 * size.height,
                    ),
                    Card(
                      elevation: 10,
                      shadowColor: Colors.black45,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // EMAIL
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Design.bottom,
                                hintText: 'Email',
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                focusedBorder: AppStyles.textFieldFocusedBorder,
                                enabledBorder: AppStyles.textFieldEnabledBorder,
                              ),
                              validator: (value) =>validateLoginScreen(fieldName: 'email'),
                              // {
                              //   if (value == null || value.isEmpty) {
                              //     return "Email cannot be empty";
                              //   }

                              //   if (!RegExp(
                              //     r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$",
                              //   ).hasMatch(value)) {
                              //     return "Please enter a valid email";
                              //   }

                              //   return null;
                              // },
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 20),

                            // PASSWORD
                            TextFormField(
                              controller: passwordController,
                              obscureText: _isObscure3,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isObscure3
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure3 = !_isObscure3;
                                    });
                                  },
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Password',
                                errorText: passwordError,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                                focusedBorder: AppStyles.textFieldFocusedBorder,
                                enabledBorder: AppStyles.textFieldEnabledBorder,
                              ),
                              validator:(value)=>validateLoginScreen(fieldName: 'password'),
                              //  (value) 
                              //  {
                              //   if (value == null || value.isEmpty) {
                              //     return "Password cannot be empty";
                              //   }

                              //   if (value.length < 6) {
                              //     return "Please enter valid password min. 6 characters";
                              //   }

                              //   return null;
                              // },
                              keyboardType: TextInputType.text,
                            ),

                            const SizedBox(height: 20),

                            // FORGOT PASSWORD
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Forgot password",
                                  style: AppStyles.submitBtnTextStyle,
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),

                            // LOGIN BUTTON
                            ElevatedButton(
                              onPressed: () {
                              

                                // add validation logic
                                String? emailError=validateLoginScreen(fieldName: 'email');
                                // if(emailError)
                                String? passwordError=validateLoginScreen(fieldName: 'password');
                                  setState(() {
                                  visible = true;
                                });
                                if(emailError==null && passwordError==null){
                                isLoadingLogin = true;

                                signIn(
                                  emailController.text,
                                  passwordController.text,
                                );  
                                }
                                
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(
                                  double.infinity,
                                  50,
                                ),
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Log in",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  isLoadingLogin
                                      ? const SizedBox(
                                          width: 10,
                                        )
                                      : SizedBox(),
                                  isLoadingLogin
                                      ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ))
                                      : SizedBox(),
                                ],
                              ),
                            ),

                            const SizedBox(height: 25),

                            // SIGN UP
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Create new Account?",
                                  style: AppStyles.authQuestionQuoteStyle,
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Register(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: AppStyles.submitBtnTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

String?passwordError;
String?emailError;

  String?validateLoginScreen({required String fieldName}){
    String ?errorMessage;
       
    switch(fieldName){
      case 'email': 
      String ?value=emailController.text;

      if (value == null || value.isEmpty) {
                                  errorMessage= "Email cannot be empty";
                                }

                                if (!RegExp(
                                  r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$",
                                ).hasMatch(value)) {
                                  errorMessage= "Please enter a valid email";
                                }
emailError=errorMessage;
 print('email error is $emailError');
        
        break;
      case 'password': 
        String ?value=passwordController.text;

         if (value == null || value.isEmpty) {
                                 errorMessage= "Password cannot be empty";
                                }

                                if (value.length < 6) {
                                  errorMessage= "Please enter valid password min. 6 characters";
                                }

                                passwordError=errorMessage;


        break;
    }
    return errorMessage;
    
  }

  // bool validateLoginScreen(){
  //   bool isValid=false;
    
  //   if(passwordController.text.isNotEmpty && emailController.text.isNotEmpty){
  //     isValid=true;
  //   }
 
  //   return isValid;
  // }

  void route({required String role}) {
    if (role == 'Company') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Companybottom(),
        ),
      );
    } else if(role=='Admin'){
       Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdminHomeScreen(),
        ),
      );
    }
    else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Workersbottom(),
        ),
      );
    }
   
  }

  void signIn(String email, String password) async {
    if (!_formkey.currentState!.validate()) return;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: email.trim(), password: password.trim());

      if (userCredential.user != null) {
      
        await getUserDetails(
            id: userCredential.user!.uid, passWord: password.trim());
      }
    } on FirebaseAuthException catch (e) {
      print('exception is found in login ${e.toString()}');
      print('exception is found in login ${e.message}');

      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      isLoadingLogin = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Login failed")),
      );
    }
  }

  Future<void> getUserDetails(
      {required String id, required String passWord}) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(id).get();

      if (doc.exists) {
        Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

        print("User details: $userData");
        isLoadingLogin = false;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login Success"),
          ),
        );

        await LocalStorage.storeLoggedInfo(
            loggedUserModel: LoggedUserModel(
                userName: userData['email'],
                role: userData['rool'],
                password: passWord));

        route(role: userData['rool']);
      } else {
        print("User document does not exist");
      }
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }
}

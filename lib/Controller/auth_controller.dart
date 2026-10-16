import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_project/Constants/field_names.dart';
import 'package:job_project/Model/logged_user_model.dart';
import 'package:job_project/Model/password_change_mdl.dart';
import 'package:job_project/Repository/local_storage.dart';
import 'package:job_project/Utils/validations_utils.dart';

class AuthController extends ChangeNotifier{


    TextEditingController userNameTxtEditingController=TextEditingController();
    TextEditingController passwordTxtEditingController=TextEditingController();
    String userNameError='';
    String passwordError='';

    bool isLoadingLogin=false;
    bool isLoginBtnPressed=false;
    bool isValidFields=false;

  // login
    void attemptLogin()async{
       

    }

    void validateLogin(){
      

    }

  // logout



   
  // register


  // change password

  LoggedUserModel ?loggedUserModel;

    TextEditingController currentPasswordTextEditingController=TextEditingController();
    TextEditingController newPasswordTxtEditingController=TextEditingController();
    TextEditingController confirmPasswordTextEditingController=TextEditingController();

  String errorCurrentPasswordErrror = '';
  String errorNewPassword = '';
  String errorConfirmPassword = '';


  Future<bool> changePassword(
    BuildContext context,
    // ChangePasswordModel passwordModel,
  ) async {

      errorCurrentPasswordErrror = '';
      errorNewPassword = '';
      errorConfirmPassword = '';


    if(loggedUserModel==null){
      loggedUserModel= await LocalStorage.getLoggedUser();
    }
    try {

      InputValidationClasss passwordValidation= ValidationsUtils.isValidPassword(
        password:currentPasswordTextEditingController.text);
      //  passwordModel.currentPassword);
      
       errorCurrentPasswordErrror=passwordValidation.errorMessage;
      
      if(!passwordValidation.isValid){
        //   ScaffoldMessenger.of(context).showSnackBar(
        //    SnackBar(
        //     content: Text(passwordValidation.errorMessage),
        //   ),
        // );

        return false;
      }
      // else if(!loggedUserModel!.password!.contains(passwordModel.currentPassword)){
        

      //   return false;
      // }

      InputValidationClasss newPasswordValidation= ValidationsUtils.isValidPassword(password: newPasswordTxtEditingController.text);
      errorNewPassword=newPasswordValidation.errorMessage;
      // passwordModel.newPassword);
      if(!newPasswordValidation.isValid){
        //   ScaffoldMessenger.of(context).showSnackBar(
        //    SnackBar(
        //     content: Text(newPasswordValidation.errorMessage),
        //   ),
        // );

        return false;
      }


      InputValidationClasss confirmPasswordValidation= ValidationsUtils.isValidConfirmPassword(
        confirmPassword: confirmPasswordTextEditingController.text,password: newPasswordTxtEditingController.text
        
        //  passwordModel.confirmPassword,password: passwordModel.newPassword
        );

        errorConfirmPassword=confirmPasswordValidation.errorMessage;
      if(!confirmPasswordValidation.isValid){
        //   ScaffoldMessenger.of(context).showSnackBar(
        //    SnackBar(
        //     content: Text(confirmPasswordValidation.errorMessage),
        //   ),
        // );

        return false;
      }

      // Check logged-in user
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text("User is not logged in"),
        //   ),
        // );
        return false;
      }

      if (user.email == null) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(
        //     content: Text("This account does not have an email login"),
        //   ),
        // );
        return false;
      }

      // Reauthenticate
      final AuthCredential credential =
          EmailAuthProvider.credential(
        email: user.email!,
        password: currentPasswordTextEditingController.text//passwordModel.currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPasswordTxtEditingController.text);//.newPassword);

      if (!context.mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password changed successfully"),
          backgroundColor: Colors.green,
        ),
      );

      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          errorMessage = "Current password is incorrect";
          break;

        case 'weak-password':
          errorMessage = "New password is too weak";
          break;

        case 'requires-recent-login':
          errorMessage =
              "Please log in again before changing your password";
          break;

        case 'network-request-failed':
          errorMessage =
              "Network error. Please check your internet connection";
          break;

        case 'user-not-found':
          errorMessage = "User account not found";
          break;

        default:
          errorMessage =
              "Unable to change password. Please try again";
      }

      if (!context.mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );

      return false;
    } catch (e) {
      if (!context.mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong. Please try again"),
          backgroundColor: Colors.red,
        ),
      );

      return false;
    }
  }

  void isValidResetPassword({required String fieldName})async{

     if(loggedUserModel==null){
      loggedUserModel= await LocalStorage.getLoggedUser();
    }

    switch(fieldName){
      case FieldNames.currentPassoword:
      InputValidationClasss currentPasswordValidation=ValidationsUtils.isValidPassword(password: currentPasswordTextEditingController.text);
        errorCurrentPasswordErrror=currentPasswordValidation.errorMessage;
        print('loggedUserModel!.password is ${loggedUserModel!.password}');
        if(errorCurrentPasswordErrror==''){
          if(!loggedUserModel!.password!.contains(currentPasswordTextEditingController.text)){
            errorCurrentPasswordErrror='Please enter your current password';
          }else{
            errorCurrentPasswordErrror='';
          }
        }

        print('errorCurrentPasswordErrror is $errorCurrentPasswordErrror');
       break;
       case FieldNames.newPassoword:
       InputValidationClasss newPasswordValidation=ValidationsUtils.isValidPassword(password: newPasswordTxtEditingController.text);
        errorNewPassword=newPasswordValidation.errorMessage;
         print('errorNewPassword is $errorNewPassword');
       break;
       case FieldNames.confirmPassoword:
       InputValidationClasss confirmPasswordValidation=ValidationsUtils.isValidConfirmPassword(
        password: newPasswordTxtEditingController.text,confirmPassword: confirmPasswordTextEditingController.text);
        errorConfirmPassword=confirmPasswordValidation.errorMessage;

       break;
    }
    notifyListeners();
  }


  void clearChangePasswordFields(){
    errorConfirmPassword='';
    errorNewPassword='';
    errorCurrentPasswordErrror='';
    currentPasswordTextEditingController.clear();
    newPasswordTxtEditingController.clear();
    confirmPasswordTextEditingController.clear();
    notifyListeners();
  }


}
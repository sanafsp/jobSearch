class ValidationsUtils{

  ValidationsUtils._();

 

 static RegExp emailRegExp=RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$");
 static int passwordMinLength=6;


 static InputValidationClasss isValidEmail({String?email}){
  String errorMsg='';
  bool isValid=false;
   if(email==null||email.isEmpty){
      errorMsg='Email cant be empty!';
   }else if(!emailRegExp.hasMatch(email)){
     errorMsg='Enter a valid email !';
   }else{
    errorMsg='';
    isValid=true;
   }
  return InputValidationClasss(isValid: isValid, errorMessage: errorMsg);
 }

 static InputValidationClasss isValidPassword({String?password}){
   String errorMsg='';
  bool isValid=false;
    if(password==null||password.isEmpty){
    errorMsg='Password cant be empty!';
    }else if(password.length<passwordMinLength){
     errorMsg='Please enter valid password min. 6 characters!';
    }else{
      errorMsg='';
      isValid=true;
    }
    return InputValidationClasss(isValid: isValid, errorMessage: errorMsg);
 }

 static InputValidationClasss isValidConfirmPassword({String?password,String?confirmPassword}){
   String errorMsg='';
  bool isValid=false;
    if(confirmPassword==null||confirmPassword.isEmpty){
    errorMsg='Field cant be empty!';
    }else if(confirmPassword!=password){
     errorMsg='Password doesnot match!';
    }else if(confirmPassword==password){
      errorMsg='';
      isValid=true;
    }else{

    }
    return InputValidationClasss(isValid: isValid, errorMessage: errorMsg);
 }
    
}

class InputValidationClasss{
 
 bool isValid;
 String errorMessage;

 InputValidationClasss({required this.isValid,required this.errorMessage});
}
import 'package:shared_preferences/shared_preferences.dart';
import 'package:job_project/Model/logged_user_model.dart';
class LocalStorage{

  LocalStorage._();


  static String userName='USER_NAME';
  static String password='PASSWORD';
  static String role='ROLE';
  static String userId='USER_ID';

 
  // store logged info
  static Future storeLoggedInfo({required LoggedUserModel loggedUserModel})async{

  final SharedPreferences prefs = await SharedPreferences.getInstance();



await prefs.setString(role, loggedUserModel.role??'');

await prefs.setString(userName, loggedUserModel.role??'');

await prefs.setString(password, loggedUserModel.password??'');

  }
 

  // is logged in

 static Future<bool>  isLoggedIn()async{
   print('inside is loggedin check');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
 
 bool result=false;

if(prefs.containsKey(userName)){
  print('inside pref contains userName');
 String ?username= await prefs.getString(userName);
  result =username==null||username==''?false:true;
}
 print('username is $userName');
return result;
  }

  static Future<LoggedUserModel> getLoggedUser()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String ?username= await prefs.getString(userName);
    String ?passworD= await prefs.getString(password);
    String ?rolE= await prefs.getString(role);

      return LoggedUserModel(userName: username,password: passworD,role: rolE);

  }

  // delete logged info
  static Future deleteLoggedUserInfo()async{
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     await prefs.remove(userName);
     await prefs.remove(password);
     await prefs.remove(role);
  }

  // update password
  Future updatePassword({required String newPassword})async{
   final SharedPreferences prefs = await SharedPreferences.getInstance();
   await prefs.remove(password);
   await prefs.setString(password, newPassword);
  }

}
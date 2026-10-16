class LoggedUserModel {

  String? userName;
  String? password;
  String?role;



  LoggedUserModel({this.userName,this.password,this.role});



  LoggedUserModel.fromJson({required Map<String,dynamic> json, required String passwordTyped}){
    userName=json['username'];
    password=passwordTyped;
    role=json['role'];
  }

  Map<String,dynamic> toJson(){

    return{
     'username': userName,
      'password':password,
      'role':role
    };
  }


}
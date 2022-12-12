import 'package:site_safety/util/utils.dart';



class Validators{

 //Validation for email field
 String emailValidate(String email){
    if(Utils.instance.emailReg(email)){
      return null;
    }else{
      return "Please enter valid email";
    }
  }

 //Validation for password field
 String passwordValidate(String password){
   if(password.length > 5){
     return null;
   }else{
     return "Password must be at least 6 characters";
   }
 }

//Validation for name field
 String nameValidate(String name){
        if(name.length > 0){
        return null;
        }else{
        return "Enter your name";
        }

 }

  //For title field
 String titleValidate(String title){
        if(title.length > 0){
        return null;
        }else{
        return "*Please enter title";
        }

 }

 //For message filed
 String messageValidate(String message){
        if(message.length > 0){
        return null;
        }else{
        return "*Please enter message";
        }

 }

 //For phone no. filed
String phoneValidate(String phone) {
  if (phone.length >= 10) {
    return null;
  } else {
    return "phone number must be at least 10 digits";
  }
}

}
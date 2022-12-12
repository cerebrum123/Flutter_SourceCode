import 'package:Firebase_chat/UI/screens/Login.dart';
import 'package:Firebase_chat/UI/screens/users_list.dart';
import 'package:Firebase_chat/UI/widgets/app_bar.dart';
import 'package:Firebase_chat/fcm/notification.dart';
import 'package:Firebase_chat/provider/firebase_provider.dart';
import 'package:Firebase_chat/utils/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';


class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  //FireStore instance
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  //FCM class instance
  final firebaseMessaging = FCM();

  //TextFields controller
  final _fullName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  SharedPreferences _prefs;

  //Global key for textFields validation
  final _formKey = GlobalKey<FormState>();

  //Preferences obj and values for check user is already exist or not
  Future<List> getPreferences()async{
   _prefs = await SharedPreferences.getInstance();
   final boolVal = _prefs.getBool(IS_FIRST_TIME);
   final uID = _prefs.getString(CURRENT_USER_ID);
   var list = [boolVal,uID];
    return list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseMessaging.setNotification(context);
    getPreferences().then((value){
      debugPrint("value pref >>> $value");
      if(value[0] != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (builder) => UsersList(currentUserId: value[1],)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "Register to Firebase",),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _fullName,
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                hintText: "FullName"
              ),),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _email,
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "Email"
                ),),
              TextFormField(
                obscureText: true,
                controller: _phone,
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    hintText: "Password"
                ),),
              SizedBox(height: 10,),
              TextButton(onPressed:(){
                if(_formKey.currentState.validate()){
                  //Get signUp method from provider with read access
                  context.read<FirebaseProvider>().signUp(_email.text, _phone.text,context,_fullName.text);
                }
                }, child: Text("Register")),
              SizedBox(height: 30,),
              TextButton(onPressed: (){Navigator.push(
                  context, MaterialPageRoute(builder: (builder) => Login()));}, child: Text("Go to Login"))
            ],
          ),
        ),
      ),
    );
  }
}

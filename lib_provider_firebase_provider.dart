

import 'package:Firebase_chat/UI/screens/Login.dart';
import 'package:Firebase_chat/UI/screens/users_list.dart';
import 'package:Firebase_chat/utils/const.dart';
import 'package:Firebase_chat/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseProvider with ChangeNotifier{
  //user collection ref obj
  CollectionReference users = Utilities().fireStore.collection('users');
  SharedPreferences _prefs;


  //Stream to get users from fireStore
  Stream<QuerySnapshot> streamOfUsers() => users.snapshots();


  //Register a user with email pass and return results
  Future<void> signUp(String email,String pass,BuildContext context,String _fullName) async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: pass
      ).then((value){
        addUser(_fullName,context,value.user.uid);
        return value;
      });
      debugPrint("firebase register user >>>$userCredential");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Utilities.showErrorMessage('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Utilities.showErrorMessage('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  //Add every user to fireStore then go to login
  Future<void> addUser(String fullName,BuildContext context,String uID) async{
    _prefs = await SharedPreferences.getInstance();
    return users.doc(uID)
        .set({
      'full_name': fullName,
      'createdOn' : FieldValue.serverTimestamp()
    })
        .then((value) {
      _prefs.setBool(IS_FIRST_TIME, true);
      _prefs.setString(CURRENT_USER_ID, uID);
      print("User Added >>> $uID");
      Navigator.push(
          context, MaterialPageRoute(builder: (builder) => Login(uID: uID,)));
    })
        .catchError((error) => print("Failed to add user: $error"));
  }

  //Login user to firebase with email pass then go to home page
  Future<void> loginWithEmailPassword(String email,String pass,BuildContext context) async{
    _prefs = await SharedPreferences.getInstance();
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: pass
      ).then((value) {
        print('${value.user.uid}');
        _prefs.setBool(IS_FIRST_TIME, true);
        _prefs.setString(CURRENT_USER_ID, value.user.uid);
        Utilities.showSuccessMessage("Logged In successfully");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (builder) => UsersList(currentUserId:value.user.uid)));
        return value;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Utilities.showErrorMessage("No user found for that email.");
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        Utilities.showErrorMessage("Wrong password provided for that user.");
        print('Wrong password provided for that user.');
      }
    }
  }


}
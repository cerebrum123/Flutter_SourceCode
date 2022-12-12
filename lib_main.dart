import 'package:Firebase_chat/provider/firebase_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'UI/screens/register.dart';


//firebase initialization
Future init()async{
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }catch(e){
    print(e);
  }

}

//Application main method with providers
void main() async{
  await init();
  runApp(MultiProvider(
   providers: [
     ChangeNotifierProvider<FirebaseProvider>(create: (_)=> FirebaseProvider()),
     StreamProvider<QuerySnapshot>(create: (context) => context.read<FirebaseProvider>().streamOfUsers(), initialData: null)
   ],
    builder: (context, child){
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Register()
      );
    }
  ));
}
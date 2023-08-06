import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_court/views/homepage.dart';
import 'package:food_court/views/login.dart';

import 'helperfuctions/helperfunctions.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? userIsLoggedIn;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }
  getLoggedInState()async{
    await HelperFunction.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primaryColor:  Colors.orange[900],
      ),
      routes: {
        'home':(context)=>HomePage(),
        'login':(context)=>LoginScreen()
      },
      home: userIsLoggedIn != null ? userIsLoggedIn! ?  HomePage():
      LoginScreen():LoginScreen(),
    );
  }
}


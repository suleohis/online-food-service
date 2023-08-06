import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:food_court/modal/cart_item.dart';
import 'package:food_court/views/homepage.dart';
import 'package:food_court/views/login.dart';
import 'package:food_court/widget/widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'database.dart';
import 'helperfunctions.dart';

class Authentication{
  static Future<FirebaseApp> initializeFirebase()async{
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    return firebaseApp;
  }

  static Future<void> signWithGoogle({required BuildContext context})async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    // bool checkIfCreated = auth.currentUser!.uid.isEmpty;

      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      if(googleSignInAccount != null){
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken
        );

        try{
          final UserCredential userCredential =
          await auth.signInWithCredential(credential);
          List<CartItemModel>cart = [];
         FirebaseAuth firebaseAuth=  FirebaseAuth.instance;
          user = userCredential.user;
          Map<String, dynamic> userMap ={
            'name':user!.displayName,
            'email':user.email,
            'cart':cart,
            'id':firebaseAuth.currentUser!.uid,
            'role':'customer',
            'Log check': 'Sign In',
            'LogOut time':  DateTime.parse(DateTime.now().toIso8601String())
          };
          Map<String, dynamic> userMaps ={
            'Log check': 'Sign In',
            'LogOut time':  DateTime.parse(DateTime.now().toIso8601String())
          };

          HelperFunction.saveUserLoggedInSharedPreference(true);
          HelperFunction.saveUserNameSharedPreference(user.displayName!);
          HelperFunction.saveUserEmailSharedPreference(user.email!);
          ///Come back here
          // checkIfCreated ?
          DatabaseMethods().uploadUserInfo(userMap,context);
              // :
          // DatabaseMethods().updateUserInfo(userMaps, context);
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
          print('it is working well kdkd');
        }on FirebaseAuthException catch (e){
          if(e.code == 'account-exists-with-different-credential'){
            ScaffoldMessenger.of(context).showSnackBar(
                Authentication.customSnackBar(
                  content:
                  'The account already exists with a different credential',
                )
            );
          }
          else if(e.code == 'invalid-credential'){
            ScaffoldMessenger.of(context).showSnackBar(
                Authentication.customSnackBar(
                  content:
                  'Error occurred while accessing credentials. Try again.',
                )
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );

      }
    }
  }

  static SnackBar customSnackBar({required String content}){
    return SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          content,
          style: TextStyle(color: Colors.redAccent,letterSpacing: 0.5),
        )
    );
  }

  static Future<void> signOUt({required BuildContext context})async{
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final SharedPreferences pref = await SharedPreferences.getInstance();
    try{
      String? email = await HelperFunction.getUserEmailSharedPreference();
      String? name = await HelperFunction.getUserNameSharedPreference();
      // if(!KIsWeb){
      //   await googleSignIn.signOut();
      // }
      // await FirebaseAuth.instance.signOut();
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      Map<String, dynamic> userMap ={
        'name':name,
        'email':email,
        'Log check': 'Sign Out',
        'LogOut time':  DateTime.parse(DateTime.now().toIso8601String())
      };
      DatabaseMethods().updateUserInfo(userMap,context);
      pref.clear();
      ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
              content: 'Done Thanks.'
          )
      );
      Navigator.popUntil(context, ModalRoute.withName('home'));
      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
    }catch (e){
      ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
              content: 'Error signing out. Try again.'
          )
      );
    }
  }
}
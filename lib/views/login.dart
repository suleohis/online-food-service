import 'dart:io';

import 'package:flutter/material.dart';

import 'package:food_court/helper/style.dart';
import 'package:food_court/helperfuctions/auth.dart';
import 'package:food_court/views/homepage.dart';
import 'package:food_court/views/signUp.dart';
import 'package:food_court/widget/custom_text.dart';
import 'package:food_court/widget/widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<ScaffoldState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height - 50,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 150,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/logo.png",
                    width: 200,
                    height: 200,
                  ),
                ],
              ),
              const SizedBox(
                height: 150,
              ),
              Align(alignment: Alignment.bottomCenter, child: googleButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget googleButton() {
    return GestureDetector(
      onTap: () {
        checkInternetConnection();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.orange[900], borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Center(
              child: isLoggedIn ? const CircularProgressIndicator(color: Colors.white,) : Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 15,
              ),
              Image.asset('assets/images/googleIcon.png'),
              const SizedBox(
                width: 15,
              ),
              const Text(
                'Google',
                style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
        ),
      ),
    );
  }

  checkInternetConnection() async {
    setState(() {
      isLoggedIn = true;
    });
    bool passed = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Authentication.signWithGoogle(context: context);
        print('connected');
      }
    } on SocketException catch (_) {

      showSnack(context, 'Please Check Your Internet Connection');
      print('not connected');
    }
  }
}

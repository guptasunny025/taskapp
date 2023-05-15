// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_app/screens/home_screen.dart';
import 'package:task_app/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  final bool auth;
  const SplashScreen({super.key, required this.auth,});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 2;

  @override
  void initState() {
    super.initState();
   _loadWidget() ;
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    widget.auth == true
        ? Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const HomeScreen()))
        : Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const LoginScreen()));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        // backgroundColor: Color(0xFF198A6F),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            // color: Color(#198A6F),

            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  width: deviceSize.width / 2 * .6,
                  height: deviceSize.height / 4 * .6 * .9,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFF4284F3)),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                  )),
            )));
  }
}

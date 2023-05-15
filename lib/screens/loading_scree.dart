// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  
  const LoadingScreen();

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
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

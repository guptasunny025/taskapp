// ignore_for_file: sort_child_properties_last, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
        body: SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        color: Colors.white,
        child: Container(
            width: double.infinity,
            height: deviceSize.height / 4 / 4,
            margin: EdgeInsets.only(
              top: deviceSize.height / 4 / 4 / 2,
              left: deviceSize.width / 4 / 4,
              right: deviceSize.width / 4 / 4,
            ),
            child: OutlinedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await Provider.of<Auth>(context, listen: false)
                      .authenticateSignin(context);
                  setState(() {
                    isLoading = false;
                  });
                },
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const FaIcon(FontAwesomeIcons.google, color: Colors.white),
                  SizedBox(
                    width: deviceSize.width / 4 / 4 / 2,
                  ),
                  isLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : Text(
                          'Continue with Google',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: deviceSize.height / 4 / 4 / 3),
                        )
                ])),
            decoration: BoxDecoration(
                color: const Color(0xFF4284F3),
                borderRadius: BorderRadius.circular(5))),
      ),
    ));
  }
}

void toast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 100,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0);
}

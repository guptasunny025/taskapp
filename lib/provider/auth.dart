// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../httpException.dart';
import '../screens/home_screen.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userId = '';
  var firestore = FirebaseFirestore.instance;
  String username = '';
  bool isSucess = false;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<dynamic> authenticateSignin(context) async {
    isSucess = false;
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      if (authResult != null) {
        userId = authResult.user!.uid.toString();
        final prefs = await SharedPreferences.getInstance();

        final userData = json.encode(
          {
            'userid': authResult.user!.uid.toString(),
            'username': authResult.user!.displayName.toString()
          },
        );
        await prefs.setString('userData', userData);
        if (userId != '') {
          username = authResult.user!.displayName.toString();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false);
        }
      }
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> addtask(String name, desc, dot) async {
    isSucess = false;
    try {
      await firestore.collection("tasks").add({
        'taskname': name.trim(),
        'taskid': DateTime.now().toString(),
        'taskdesc': desc.trim(),
        'taskdate': dot.trim(),
        'userid': userId,
      }).then((value) {
        isSucess = true;
        notifyListeners();
      });
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<dynamic> edittask(String name, desc, dot, docid, taskid) async {
    isSucess = false;
    try {
      await firestore.collection("tasks").doc(docid).update({
        'taskname': name.trim(),
        'taskid': taskid,
        'taskdesc': desc.trim(),
        'taskdate': dot.trim(),
        'userid': userId,
      }).then((value) {
        isSucess = true;
        notifyListeners();
      });
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  Future<void> deleteProduct( id) async {
    try {
      await FirebaseFirestore.instance.collection("tasks").doc(id).delete();
    } catch (e) {
      throw HttpException(e.toString());
    }
  }

  bool isauth = false;
  Future tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return isauth = false;
    }
    if (prefs.containsKey('userData')) {
      final extractedagentUserData = await json
          .decode(prefs.getString('userData') ?? '') as Map<String, dynamic>;
      // final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
      userId = await extractedagentUserData['userid'];
      username = await extractedagentUserData['username'];
      isauth = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    if (await prefs.containsKey('userData')) {
      await prefs.remove('userData');
      await _googleSignIn.signOut();
      userId = '';
      notifyListeners();
    }
  }
}

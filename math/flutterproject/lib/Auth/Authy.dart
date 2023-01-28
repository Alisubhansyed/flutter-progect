import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterproject/ChatScreen.dart';
import '../MainPage/MainPage.dart';
import '../MainPage/Naviagrionbar.dart';
import 'Signup.dart';

class Authy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return snapshot.data == null ? AuthScreen() : NAV();
      },
    );
  }
}

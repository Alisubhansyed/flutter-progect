import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<void> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login(
    permissions: [
      'openid', 'public_profile', 'email'
      // 'public_profile',
      // 'email',
      // 'pages_show_list',
      // 'pages_messaging',
      // 'pages_manage_metadata'
    ],
  );
  // FacebookLogi
  // final OAuthCredential facebookAuthCredential =
  //     FacebookAuthProvider.credential(loginResult.accessToken!.token);

  // Create a credential from the access token

  // Once signed in, return the UserCredential
  // return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Widget kHSpacer(double h) {
  return SizedBox(height: h);
}

Widget kWSpacer(double w) {
  return SizedBox(width: w);
}

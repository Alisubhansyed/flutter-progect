import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/constant.dart';

class AuthSignin extends StatefulWidget {
  const AuthSignin({super.key});

  @override
  State<AuthSignin> createState() => _AuthSigninState();
}

class _AuthSigninState extends State<AuthSignin> {
  GlobalKey key = GlobalKey<FormState>();
  TextEditingController emailin = TextEditingController();
  TextEditingController passWordIn = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: key,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                KHSpace(130),
                Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 50,
                      fontWeight: FontWeight.w600),
                ),
                KHSpace(20),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [Kboxshado]),
                  child: TextFormField(
                      controller: emailin,
                      decoration: KtextfieldStyle.copyWith(
                          prefixIcon: Icon(Icons.email_outlined),
                          hintText: 'Email')),
                ),
                KHSpace(20),
                Container(
                  decoration: BoxDecoration(
                      boxShadow: [Kboxshado],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: TextFormField(
                      controller: passWordIn,
                      obscureText: true,
                      decoration: KtextfieldStyle.copyWith(
                        prefixIcon: Icon(Icons.lock),
                        hintText: 'Passward',
                      )),
                ),
                KHSpace(20),
                KHSpace(20),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Color(0xFFFF5722),
                  onPressed: () async {
                    if (emailin.value.text == '' &&
                        passWordIn.value.text == '') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("please enter the value of empty fields!")));
                    } else {
                      try {
                        auth
                            .signInWithEmailAndPassword(
                                email: emailin.value.text,
                                password: passWordIn.value.text)
                            .then((value) {
                          Navigator.pop(context);
                        });
                      } catch (e) {
                        print("object");
                      }
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 100,
                    ),
                    child: Text(
                      "Singn In",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                KHSpace(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Creat an account ?',
                      style: TextStyle(fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'sign Up',
                        style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 15,
                            decoration: TextDecoration.underline),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

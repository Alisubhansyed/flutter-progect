import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/Auth/Signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../constant.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController passward = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String path = '';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  KHSpace(130),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 50,
                        fontWeight: FontWeight.w600),
                  ),
                  KHSpace(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            FilePickerResult? result = await FilePicker.platform
                                .pickFiles(type: FileType.image);

                            if (result != null) {
                              setState(() {
                                path = result.files.single.path.toString();
                              });
                            } else {
                              path = '';
                            }
                          },
                          child: path == ''
                              ? CircleAvatar(
                                  // backgroundImage:snapshot.hasData?snapshot.data,

                                  backgroundColor:
                                      Colors.deepOrange.withOpacity(0.7),
                                  radius: 25,
                                  child: Center(
                                      child: Icon(
                                    Icons.add_a_photo,
                                    color: Color.fromARGB(255, 245, 197, 183),
                                  )),
                                )
                              : CircleAvatar(
                                  backgroundImage: FileImage(File(path)),
                                  backgroundColor:
                                      Colors.deepOrange.withOpacity(0.7),
                                  radius: 25,
                                )),
                      // KWSpace(10),
                      Container(
                        width: width / 1.5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [Kboxshado]),
                        child: Container(
                          child: TextFormField(
                              controller: name,
                              decoration: KtextfieldStyle.copyWith(
                                  prefixIcon: Icon(Icons.person),
                                  hintText: 'Name')),
                        ),
                      ),
                    ],
                  ),
                  KHSpace(20),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [Kboxshado]),
                    child: TextFormField(
                        controller: email,
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
                        controller: passward,
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
                    color: Colors.deepOrange,
                    onPressed: () async {
                      if (path == '') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("please select a image for profile!")));
                      } else if (name.value.text == '' &&
                          email.value.text == '' &&
                          passward.value.text == '') {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "please enter the value of empty fields!")));
                      } else {
                        FirebaseStorage storeage = FirebaseStorage.instance;
                        try {
                          _auth
                              .createUserWithEmailAndPassword(
                            email: email.value.text,
                            password: passward.value.text,
                          )
                              .then((value) async {
                            Reference refu = storeage
                                .ref()
                                .child('profileImage')
                                .child(_auth.currentUser!.email.toString());
                            UploadTask uptask = refu.putFile(File(path));
                            final snapshot = await uptask.whenComplete(() {});
                            String urlProfile =
                                await snapshot.ref.getDownloadURL();
                            await _firestore
                                .collection("user")
                                .doc(_auth.currentUser!.email)
                                .set({
                              'name': name.value.text,
                              'urlProfile': urlProfile,
                              "timeOfStatus": DateTime.now().toString(),
                            });
                            print(
                                "Subahn ali oooooooooooooooooooooooooooooooooooo");
                          }).then((value) {
                            print(
                                "kjdskdakkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
                          });
                        } catch (e) {
                          print(e);
                        }
                        print(
                            "${name.value.text},${email.value.text},${passward.value.text}");
                      }
                    },
                    child: Container(
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 100,
                        ),
                        child: Text(
                          "Singn up",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  KHSpace(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account ?',
                        style: TextStyle(fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AuthSignin()));
                        },
                        child: Text(
                          'sign in',
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
      ),
    );
  }
}

import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/constant.dart';

import '../model.dart';

class Add extends StatefulWidget {
  const Add({super.key});

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController title = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController brand = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController decription = TextEditingController();
  final validatekey = GlobalKey<FormState>();
  String titleV = '';
  String priceV = '';
  String brandV = '';
  String addressV = '';
  String decriptionV = '';

  String path = '';
  bool valueForPromotion = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                if (path == '') {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text("please select at least one image for prost")));
                } else
                 {
                  if (validatekey.currentState!.validate()) {
                    Reference ref = FirebaseStorage.instance
                        .ref()
                        .child('user_Image')
                        .child('${basename(path)}');
                    UploadTask uploadTask = ref.putFile(File(path));
                    final snapshot = await uploadTask.whenComplete(() => null);

                    final urlImageUser = await snapshot.ref.getDownloadURL();

                    FirebaseFirestore firestore = FirebaseFirestore.instance;
                    ItemAddModel items = ItemAddModel(
                        title: title.value.text.toString().trim(),
                        price: price.value.text.toString(),
                        brand: brand.value.text.toString().trim(),
                        address: address.value.text.toString().trim(),
                        decription: decription.value.text,
                        urlImage: urlImageUser,
                        email: FirebaseAuth.instance.currentUser!.email
                            .toString());
                    firestore
                        .collection(valueForPromotion == false
                            ? "itemsForSell"
                            : "promotion")
                        .add(items.toMap())
                        .then((value) {
                      print("");
                      // Navigator.pop(context);
                    });

                    // Waits till the file is uploaded then stores the download url
                    // String url = await uploadTask..getDownloadURL();
                  }
                }
              },
              icon: Icon(
                CupertinoIcons.checkmark_alt_circle,
                color: Colors.deepOrange,
              ))
        ],
        title: Text(
          "Add Item",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: validatekey,
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: (() async {
                    FilePickerResult? result = await FilePicker.platform
                        .pickFiles(type: FileType.image);

                    if (result != null) {
                      setState(() {
                        path = result.files.single.path.toString();
                      });
                    } else {
                      // User canceled the picker
                    }
                  }),
                  child: AspectRatio(
                    aspectRatio: 5 / 3,
                    child: path == ''
                        ? Container(
                            child: Center(
                                child: Icon(
                              Icons.add,
                              color: Color.fromARGB(255, 247, 228, 222),
                              size: 100,
                            )),
                            decoration: BoxDecoration(
                                color: Colors.deepOrange.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20)),
                          )
                        : Image(image: FileImage(File(path))),
                  ),
                ),
                KHSpace(10),
                Text("Title"),
                TextFormField(
                  onChanged: (value) {
                    titleV = value;
                  },
                  validator: (value) {
                    return value!.isEmpty ? 'enter text!' : null;
                  },
                  controller: title,
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                    // label: Title(color: Colors.black, child: Text("Title")),
                    hintText: 'name of item',
                    border: InputBorder.none,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 207, 206, 206))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange)),
                  ),
                ),
                KHSpace(10),
                Text("price"),
                TextFormField(
                  validator: (value) {
                    return value!.isEmpty ? 'enter text!' : null;
                  },
                  onChanged: (value) {
                    priceV = value;
                  },
                  controller: price,
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                    // label: Title(color: Colors.black, child: Text("Title")),
                    hintText: 'Rs ',
                    border: InputBorder.none,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 207, 206, 206))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange)),
                  ),
                ),
                KHSpace(10),
                Text("Brand Name"),
                TextFormField(
                  validator: (value) {
                    return value!.isEmpty ? 'enter text!' : null;
                  },
                  onChanged: (value) {
                    brandV = value;
                  },
                  controller: brand,
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                    // label: Title(color: Colors.black, child: Text("Title")),
                    hintText: 'brand and Company name ....',
                    border: InputBorder.none,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 207, 206, 206))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange)),
                  ),
                ),
                KHSpace(10),
                Text("Address"),
                TextFormField(
                  validator: (value) {
                    return value!.isEmpty ? 'enter text!' : null;
                  },
                  onChanged: (value) {
                    addressV = value;
                  },
                  controller: address,
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                    // label: Title(color: Colors.black, child: Text("Title")),
                    hintText: 'address....',
                    border: InputBorder.none,
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 207, 206, 206))),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange)),
                  ),
                ),
                KHSpace(20),
                Text("Decription"),
                KHSpace(10),
                TextFormField(
                  validator: (value) {
                    return value!.isEmpty ? 'enter text!' : null;
                  },
                  onChanged: (value) {
                    decriptionV = value;
                  },
                  controller: decription,
                  maxLines: 10,
                  cursorColor: Colors.deepOrange,
                  decoration: InputDecoration(
                    // label: Title(color: Colors.black, child: Text("Title")),
                    hintText: 'decription about product',
                    // border: InputBorder.none,
                    // enabledBorder: InputBorder.none,
                    // disabledBorder: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange)),

                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Promotion"),
                    Switch(
                      // thumb color (round icon)
                      activeColor: Colors.deepOrange,
                      activeTrackColor: Color.fromARGB(255, 232, 239, 240),
                      inactiveThumbColor: Colors.blueGrey.shade600,
                      inactiveTrackColor: Colors.grey.shade400,
                      splashRadius: 50.0,
                      // boolean variable value
                      value: valueForPromotion,
                      // changes the state of the switch
                      onChanged: (value) {
                        valueForPromotion = value;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

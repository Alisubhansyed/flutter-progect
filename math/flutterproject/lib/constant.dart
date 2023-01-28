import 'package:flutter/material.dart';

var KmainPageTitleStye = TextStyle(
    fontWeight: FontWeight.w500,
    color: Color.fromARGB(255, 117, 117, 117),
    fontSize: 15);
var KmainPagePriceStye =
    TextStyle(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 15);
var KmainpageTimeStyle = TextStyle(
    fontWeight: FontWeight.w500,
    color: Color.fromARGB(255, 146, 145, 145),
    fontSize: 13);
Color KgreyColor = Color.fromARGB(255, 146, 145, 145);
Widget KWSpace(double w) {
  return SizedBox(
    width: w,
  );
}

InputDecoration KtextfieldStyle = InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(12, 15, 12, 5),
    hintText: "Search",
    hintStyle: TextStyle(color: Colors.grey),
    prefixIcon: Icon(
      Icons.search,
      color: Colors.grey,
    ),
    fillColor: Colors.transparent,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    focusColor: Colors.transparent,
    border: OutlineInputBorder(
        gapPadding: 2, borderRadius: BorderRadius.circular(30)));

Widget KHSpace(double h) {
  return SizedBox(
    height: h,
  );
}

BoxShadow Kboxshado = BoxShadow(
    color: Color.fromARGB(255, 250, 218, 209),
    spreadRadius: 2,
    blurRadius: 3,
    offset: Offset(0, 3));

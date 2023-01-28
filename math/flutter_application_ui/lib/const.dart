import 'package:flutter/material.dart';

Widget KHspace(double h) {
  return SizedBox(
    height: h,
  );
}

Widget KWspace(double w) {
  return SizedBox(
    width: w,
  );
}
TextStyle styleTilet=TextStyle(
  color: Colors.white,
  fontSize: 20,
  fontWeight: FontWeight.w100
); 
TextStyle styleTile = TextStyle(
  color: Colors.white,
  fontSize: 17,
);

List<String> imageKaykay = [
  "asset/7.png",
  "asset/6.png",
  "asset/2.png",
  "asset/3.png",
  "asset/5.png",
  "asset/1.png",
  "asset/4.png",
];
List<Color> color = [
  Color.fromARGB(255, 45, 42, 231),
  Colors.purple,
  Colors.red,
  Colors.pink,
  Colors.blue,
  Colors.amber.shade700,
  Colors.deepOrange,
];

List<String> name = [
  "Lifetime Youth",
  "Sunny Iceland",
  "Sun Dolphin",
  "Moon Slide",
  "Lifetime youth",
  "Sunny iceland",
  "Sun dolphin"
];

List<String> tag = [
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
];

class TagName {
  TagName({this.a});
  final int? a;
  String tagobj() {
    return tag[a!];
  }
}

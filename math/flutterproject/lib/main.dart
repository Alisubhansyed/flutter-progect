import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/Auth/Signup.dart';
import 'package:flutterproject/ChatScreen.dart';
import 'package:flutterproject/constant.dart';
// import 'package:provider/single_child_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterproject/model.dart';
import 'package:path/path.dart';
import 'Auth/Authy.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (FirebaseAuth.instance.currentUser != null) {
    if (!(await FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .snapshots()
        .isEmpty)) {
      print("object");
      status.onlineStatus();
    }
  }

  const oneSec = Duration(minutes: 1);
  Timer.periodic(oneSec, (Timer t) {
    status.onlineStatus();
    print("hi");
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: Authy(),
    );
  }
}

class DetailScreen extends StatefulWidget {
  DetailScreen(
      {required this.title,
      required this.price,
      required this.address,
      required this.urlImg,
      required this.email,
      required this.decription,
      required this.brand});
  final String title;
  final String price;
  final String address;
  final String urlImg;
  final String email;
  final String decription;
  final String brand;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  List<Widget> gridList = [];
  Widget gridView() {
    for (var i = 0; i < 9; i++) {
      gridList.add(Container(
        // height: 50,
        width: 150,
        margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Condition',
              style: TextStyle(
                color: Color.fromARGB(255, 163, 158, 158),
              ),
            ),
            Text(
              'User',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            )
          ],
        ),
        // color: Colors.amber,
      ));
    }
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: gridList,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                CarouselSlider(
                  items: [
                    CachedNetworkImage(
                      imageUrl: widget.urlImg,
                      placeholder: (context, url) {
                        return Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return AspectRatio(
                          aspectRatio: 5 / 3,
                          child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 218, 226, 226),
                              ),
                              child: i),
                        );
                      },
                    );
                  }).toList(),
                  carouselController: _controller,
                  options: CarouselOptions(
                      viewportFraction: 1,
                      // autoPlay: true,
                      // enlargeCenterPage: true,
                      aspectRatio: 5 / 3,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
                IconHeaderDetail(height: height),
                Positioned(
                  bottom: 5,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [1].asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 12.0,
                            height: 12.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.deepOrange)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DetailRowHeader(
                          icon: Icons.calendar_month_outlined,
                          txt: "20 Feb 2022",
                        ),
                        DetailRowHeader(
                          icon: CupertinoIcons.checkmark_alt_circle,
                          txt: "3000 km",
                        ),
                        DetailRowHeader(
                          icon: Icons.favorite_border_outlined,
                          txt: "450",
                        ),
                        DetailRowHeader(
                          icon: Icons.visibility,
                          txt: "2525",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.title,
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.price,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Decription"),
                    Container(
                      height: height / 3.5,

                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.all(20),
                          child: Text(
                            widget.decription + widget.email,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.deepOrange.shade200,
                          borderRadius: BorderRadius.circular(20)),
                      // height: height / 3.5,
                      // width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
            AspectRatio(
              aspectRatio: 9 / 2,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        radius: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Subhan",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.deepOrange,
                              ),
                              Text(
                                "4.9",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                "(120 Review)",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Color.fromARGB(255, 73, 72, 72),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Container(
                        child: widget.email ==
                                FirebaseAuth.instance.currentUser!.email
                            ? Container(
                                width: 110,
                              )
                            : MaterialButton(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(children: [
                                    Icon(
                                      CupertinoIcons.chat_bubble_text,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Chat to Buy",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                    )
                                  ]),
                                ),
                                color: Colors.deepOrange,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                            widget.email,
                                          )));
                                }),
                      )
                    ]),
                decoration: BoxDecoration(
                    color: Colors.deepOrange.shade200,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconHeaderDetail extends StatelessWidget {
  const IconHeaderDetail({
    Key? key,
    required this.height,
  }) : super(key: key);

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height / 15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              child: Center(child: Icon(CupertinoIcons.back)),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Spacer(),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  child: Center(child: Icon(Icons.favorite_border_outlined)),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  child: Center(child: Icon(Icons.more_horiz_sharp)),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
    );
  }
}

class DetailRowHeader extends StatelessWidget {
  DetailRowHeader({required this.txt, required this.icon});

  final String txt;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          txt,
          style: TextStyle(
            color: Color.fromARGB(255, 87, 86, 86),
          ),
        )
      ],
    );
  }
}

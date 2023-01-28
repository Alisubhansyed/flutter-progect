import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ui/const.dart';
import 'package:flutter_application_ui/detail.dart';
import 'dart:math' as math;

import 'package:simple_shadow/simple_shadow.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          // primarySwatch: Colors.blueGrey,
          ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.person,
                // Icons.person_outline,
                color: Colors.black,
              ))
        ],
        leading: Drawer(),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KHspace(10),
            Text(
              "Rent a boat",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.w300),
            ),
            KHspace(30),
            MainTextFiled(),
            KHspace(5),
            Expanded(
              child: ListView.builder(
                // shrinkWrap: true,

                itemCount: imageKaykay.length,
                itemBuilder: (context, index) {
                  return MainTile(
                  
                    index: index,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MainTextFiled extends StatelessWidget {
  const MainTextFiled({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(31, 223, 218, 218),
      ),
      child: TextFormField(
          cursorColor: Color.fromARGB(96, 194, 191, 191),
          decoration: InputDecoration(
            prefixIcon: Icon(
              CupertinoIcons.search,
              size: 20,
              color: Colors.grey,
            ),

            hintText: "Search",
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                    width: 2,
                    color: Color.fromARGB(95, 216, 213, 213))),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: Color.fromARGB(95, 216, 213, 213))),
            // focusColor: Color.fromARGB(31, 207, 202, 202),
          )),
    );
  }
}

class MainTile extends StatelessWidget {
  const MainTile({
    Key? key,
   
    required this.index,
  }) : super(key: key);


  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Detail(
           
            index: index,
          ),
        ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Stack(
          children: [
            // Container(),
            Container(
              height: 200,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KHspace(20),
                    Row(
                      children: [
                        KWspace(20),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    KHspace(10),
                    Row(
                      children: [
                        KWspace(20),
                        Text(
                          name[index],
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                    color: color[index], borderRadius: BorderRadius.circular(10)),
                height: 150,
                width: MediaQuery.of(context).size.width - 40,
                // child: Expanded(child: Container()),
              ),
            ),
            Positioned(
              right: 0,
              child: Hero(
                tag:'tag$index',
                child: Container(
                  width: 170,
                  height: 180,
                  child: Center(
                    child: Transform.rotate(
                        angle: -45 * math.pi / 180,
                        child: SimpleShadow(
                          child: Image.asset(imageKaykay[index]),
                          opacity: 0.9, // Default: 0.5
                          color: Colors.black, // Default: Black
                          offset: Offset(-2, -2), // Default: Offset(2, 2)
                          sigma: 4, // Default: 2
                        )
                          
                        // Image.asset(
                        //   "asset/1.png",
                        // )
                        ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Drawer extends StatelessWidget {
  const Drawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10),
          color: Colors.black,
          width: 23,
          height: 2,
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          color: Colors.black,
          width: 27,
          height: 2,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_application_ui/const.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen>
    with TickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? animation;
  double height = 600;
  BoxFit box = BoxFit.cover;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 1), () {
      setState(() {
        height = 1000;
      });
    });
    // controller = AnimationController(
    //     vsync: this, duration: const Duration(milliseconds: 400));
    // animation = CurvedAnimation(parent: controller!, curve: Curves.bounceOut);
    // controller!.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (controller != null) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Stack(
        children: [
          Center(
            child: AnimatedContainer(
              duration: Duration(seconds: 3),
              curve: Curves.easeOutCirc,
              height: height,
              child: Image.asset(
                "asset/bg1.jpg",
                fit: box,
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: Color.fromARGB(255, 218, 215, 215).withOpacity(0.4)),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 30),
              child: Column(
                children: [
                  Text(
                    "Order Number",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                  KHspace(20),
                  Text(
                    "#12D347",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.w500),
                  ),
                  KHspace(30),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: Text(
                        "You order configration message has been sent to you email!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400)),
                  ),
                  KHspace(60),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.pink)),
                    // color: Colors.amber,
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                        child: Text("Check Email")),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
    // } else {
    //   return Scaffold(
    //     body: CircularProgressIndicator(),
    //   );
    // }
  }
}

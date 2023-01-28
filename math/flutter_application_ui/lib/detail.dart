import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';

import 'const.dart';
import 'inputDetail.dart';

class Detail extends StatefulWidget {
  Detail({
    this.index,
  });
  final int? index;

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> with SingleTickerProviderStateMixin {
  AnimationController? controller;

  Animation<Offset>? offset;
  Color colors = Colors.white;
  // Animation
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // colors = Colors.white;

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    offset = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.0, -2),
    ).animate(controller!);
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   // controller!.dispose();
  //   colors = Colors.white;
  // }

  @override
  Widget build(BuildContext context) {
    //  colors = Colors.white;

    return Scaffold(
      backgroundColor: colors,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                CupertinoIcons.person,
                // Icons.person_outline,a
                color: Colors.black,
              ))
        ],
        leading: Drawer(),
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          int sensitivity = 8;
          if (details.delta.dy > sensitivity) {
            print('Down Swipe');
          } else if (details.delta.dy < -sensitivity) {
            controller!.forward();
            Future.delayed(
                Duration(
                  milliseconds: 200,
                ), () {
              setState(() {
                colors = color[widget.index!];
              });
            });
            controller!.forward().then((value) {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (context) => InputDetail(index: widget.index),
              ))
                  .then((value) {
                controller!.reverse();
                Future.delayed(
                    Duration(
                      milliseconds: 500,
                    ), () {
                  setState(() {
                    colors = Colors.white;
                  });
                });
              });
            });
            // Future.delayed(
            //     Duration(
            //       milliseconds: 500,
            //     ), () {
            //   Navigator.of(context)
            //       .push(MaterialPageRoute(
            //     builder: (context) => InputDetail(index: widget.index),
            //   ))
            //       .then((value) {
            //     controller!.reverse();
            //   });
            // });

            // Up Swipe
          }

          // switch (controller!.status) {
          //   case AnimationStatus.completed:
          //     controller!.reverse();
          //     break;
          //   case AnimationStatus.dismissed:
          //     break;
          //   default:
          // }
        },
        child: Stack(
          children: [
            // Container(),
            Container(
              height: MediaQuery.of(context).size.height,
            ),
            Positioned(
              bottom: 0,

              child: Stack(
                // mainAxisAlignment: MainAxisAlignment.end,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color[widget.index!],
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                    ),
                    height: MediaQuery.of(context).size.height / 1.7,
                    width: MediaQuery.of(context).size.width,
                  ),
                  SlideTransition(
                    position: offset!,
                    child: Container(
                      decoration: BoxDecoration(
                          color: color[widget.index!],
                          borderRadius: BorderRadius.circular(10)),
                      height: MediaQuery.of(context).size.height / 1.7,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Positioned(
                    bottom: 150,
                    left: 100,
                    right: 100,
                    child: Hero(
                      tag: "header1",
                      child: Text(
                        textAlign: TextAlign.center,
                        name[widget.index!],
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: 100,
                    right: 100,
                    child: Hero(
                      tag: "header",
                      child: CountButton(),
                    ),
                  ),
                ],
              ),

              // child: Expanded(child: Container()),
            ),

            Positioned(
              right: MediaQuery.of(context).size.width / 3,
              bottom: MediaQuery.of(context).size.height / 3,
              child: SlideTransition(
                position: offset!,
                child: Hero(
                  tag: 'tag${widget.index}',
                  child: Container(
                    // color: Colors.amber,
                    // width: 170,
                    height: 300,
                    child: Center(
                      child: SimpleShadow(
                        child: Image.asset(imageKaykay[widget.index!]),
                        opacity: 0.9, // Default: 0.5
                        color: Colors.black, // Default: Black
                        offset: Offset(2, 2), // Default: Offset(2, 2)
                        sigma: 7, // Default: 2
                      ),
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

class CountButton extends StatelessWidget {
  const CountButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      height: 50,
      width: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            child:
                IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.minus)),
          ),
          Text(
            "1",
            style: TextStyle(fontSize: 25),
          ),
          Material(child: IconButton(onPressed: () {}, icon: Icon(Icons.add))),
        ],
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

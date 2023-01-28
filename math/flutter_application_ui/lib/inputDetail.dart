import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ui/const.dart';
import 'package:flutter_application_ui/detail.dart';
import 'package:flutter_application_ui/finalScreen.dart';

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const EmailScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1, 0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class InputDetail extends StatelessWidget {
  InputDetail({this.index});
  final int? index;
  final TextEditingController controllerFrom = TextEditingController();
  final TextEditingController controllerTo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: color[index!],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 3.4,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Positioned(
                    top: 50,
                    left: 100,
                    right: 100,
                    child: Hero(
                      tag: "header1",
                      child: Text(
                        textAlign: TextAlign.center,
                        name[index!],
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 110,
                    left: 100,
                    right: 100,
                    child: Hero(tag: "header", child: CountButton()),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Deciption",
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "2 storage platform with bungne card located both the font and near of the kayak ",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w300),
                ),
              ),
              KHspace(50),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    controllerFrom.text.isEmpty
                        ? MainTextFiled(
                            controller: controllerFrom,
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Text(controllerFrom.text),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                          ),

                    // Spacer(),
                    controllerTo.text.isEmpty
                        ? MainTextFiled(
                            controller: controllerTo,
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            child: Text(controllerFrom.text),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                          ),
                  ],
                ),
              ),
              KHspace(30),
              ListDetail(
                lead: Text(
                  "Paddle",
                  style: styleTile,
                ),
                trail: Text(
                  "\$28.25",
                  style: styleTilet,
                ),
              ),
              ListDetail(
                lead: Text(
                  "Life West",
                  style: styleTile,
                ),
                trail: Text(
                  "\$12.50",
                  style: styleTilet,
                ),
              ),
              ListDetail(
                lead: Text(
                  "Paddle",
                  style: styleTile,
                ),
                trail: Text(
                  "\$10.00",
                  style: styleTilet,
                ),
              ),
              KHspace(30),
              ListDetail(
                lead: Text(
                  "Tolal",
                  style: styleTile,
                ),
                trail: Text(
                  "\$50.75",
                  style: styleTilet.copyWith(
                      fontWeight: FontWeight.w500, fontSize: 25),
                ),
              ),
              KHspace(50),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.amber)),
                  // color: Colors.amber,
                  child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      child: Text("Check Email")),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>EmailScreen()));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ListDetail extends StatelessWidget {
  const ListDetail({
    Key? key,
    required this.lead,
    required this.trail,
  }) : super(key: key);
  final Text lead;
  final Text trail;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListTile(
        leading: lead,
        trailing: trail,
      ),
    );
  }
}

class MainTextFiled extends StatelessWidget {
  const MainTextFiled({
    required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: TextFormField(
          keyboardType: TextInputType.datetime,
          controller: controller,
          cursorColor: Color.fromARGB(255, 238, 238, 238),
          decoration: InputDecoration(
            hintText: "dd/mm/yyyy",
            hintStyle: TextStyle(
              color: Color.fromARGB(255, 223, 221, 221),
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.transparent)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.transparent)),
          )),
    );
  }
}

import 'package:flutter/material.dart';

class ClipSelection extends StatelessWidget {
  const ClipSelection({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 14 / 2,
      child: Container(
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              // height: height / 15,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              // width: width / 5,
              child: Center(
                child: Text("Data"),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    width: 2, color: Color.fromARGB(255, 238, 237, 237)),
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}
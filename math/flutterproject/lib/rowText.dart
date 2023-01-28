import 'package:flutter/material.dart';

class TextRow extends StatelessWidget {
  TextRow({
    required this.mainTXt,
    required this.secTXt,
    required this.secRouting,
  });
  final String mainTXt;

  final String secTXt;
  final Function secRouting;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          mainTXt,
          style: TextStyle(
              fontWeight: FontWeight.w700,
              // color: Colors.
              fontSize: 17),
        ),
        InkWell(
          onTap: secRouting(),
          child: Text(
            secTXt,
            style: TextStyle(color: Color.fromARGB(255, 204, 202, 202)),
          ),
        ),
      ],
    );
  }
}

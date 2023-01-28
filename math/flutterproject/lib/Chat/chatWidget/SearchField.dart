
import 'package:flutter/material.dart';

import '../../constant.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
        style: TextStyle(color: Colors.grey),
        cursorColor: Color.fromARGB(255, 160, 158, 158),
        decoration: KtextfieldStyle);
  }
}
import 'package:flutter/material.dart';

class MyDivider extends StatelessWidget {
  MyDivider({this.color, this.height});

  Color? color;
  dynamic height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color,
    );
  }
}

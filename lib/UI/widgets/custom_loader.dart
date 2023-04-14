import 'package:flutter/material.dart';

class CustomLoader extends StatefulWidget {
  CustomLoader({super.key, required this.isVisible, this.setColor});

  bool isVisible = false;
  Color? setColor;
  @override
  State<CustomLoader> createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: Center(
        child: SizedBox(
          height: 25.0,
          width: 25.0,
          child: CircularProgressIndicator(
            color: widget.setColor,
            strokeWidth: 2.0,
          ),
        ),
      ),
    );
  }
}

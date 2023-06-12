import 'package:flutter/material.dart';

class SubmitBtn extends StatelessWidget {
  SubmitBtn({required this.name, required this.onPressed});

  String name;
  Function? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.0,
      width: double.infinity, // width: 343.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        )),
        onPressed: () {
          onPressed!();
        },
        child: Text(
          name,
          style: const TextStyle(fontSize: 16.0),
        ),
      ),
    );
  }
}

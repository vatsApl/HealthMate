import 'package:flutter/material.dart';

class BGImages extends StatelessWidget {
  BGImages({
    this.imagePath,
    this.text1,
  });

  String? imagePath;
  String? text1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            imagePath!,
            fit: BoxFit.cover,
          ),
          Center(
            child: Text(
              text1 ?? '',
              style: const TextStyle(
                fontSize: 30.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

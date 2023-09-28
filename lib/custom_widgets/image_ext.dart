import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

extension SvgLoader on Widget {
  static SvgPicture load(String fileName) {
    return SvgPicture.asset(
      fileName,
      fit: BoxFit.scaleDown,
    );
  }

  static SvgPicture loadFill(String fileName) {
    return SvgPicture.asset(
      fileName,
      fit: BoxFit.fill,
    );
  }

  static SvgPicture loadWithColor(String fileName, Color color) {
    return SvgPicture.asset(
      fileName,
      fit: BoxFit.scaleDown,
      color: color,
    );
  }

  static SvgPicture loadFillwithSize(String fileName) {
    return SvgPicture.asset(
      fileName,
      fit: BoxFit.cover,
      height: 30,
      width: 30,
    );
  }

  static SvgPicture loadWithColorandSize(String fileName, Color color) {
    return SvgPicture.asset(
      fileName,
      fit: BoxFit.cover,
      color: color,
      height: 15,
      width: 15,
    );
  }

  static SvgPicture loadcoverwithCustomSize(
      String fileName, double height, double width) {
    return SvgPicture.asset(
      fileName,
      fit: BoxFit.cover,
      height: height,
      width: width,
    );
  }
}

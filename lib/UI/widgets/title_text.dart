import 'package:clg_project/constants.dart';
import 'package:flutter/material.dart';

import '../../resourse/app_colors.dart';

class TitleText extends StatelessWidget {
  TitleText({super.key, required this.title});

  String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 26.0,
        color: AppColors.kDefaultPurpleColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

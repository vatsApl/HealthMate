import 'package:clg_project/UI/widgets/custom_loader.dart';
import 'package:clg_project/constants.dart';
import 'package:flutter/material.dart';

import '../resourse/app_colors.dart';
import '../resourse/dimens.dart';

class OutlinedBtn extends StatelessWidget {
  OutlinedBtn(
      {this.isLoading = false,
      required this.btnTitle,
      required this.onPressed,
      this.bgColor,
      this.textColor});

  String btnTitle;
  bool isLoading;
  Function? onPressed;
  Color? bgColor;
  Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimens.pixel_35,
      child: OutlinedButton(
        onPressed: () {
          onPressed!();
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Dimens.pixel_6,
            ),
          ),
        ),
        child: !isLoading
            ? Text(
                btnTitle,
                style: const TextStyle(
                  fontSize: Dimens.pixel_10,
                  color: AppColors.kDefaultPurpleColor,
                  fontWeight: FontWeight.w500,
                ),
              )
            : CustomLoader(
                isVisible: isLoading,
                setColor: Colors.white,
              ),
      ),
    );
  }
}

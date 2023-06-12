import 'package:clg_project/UI/widgets/custom_loader.dart';
import 'package:flutter/material.dart';

import '../resourse/dimens.dart';

class ElevatedBtn extends StatelessWidget {
  ElevatedBtn(
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
      width: double.infinity,
      height: Dimens.pixel_44,
      child: ElevatedButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null ? bgColor : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.pixel_6),
          ),
        ),
        child: !isLoading
            ? Text(
                btnTitle,
                style: TextStyle(
                  fontSize: Dimens.pixel_16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
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

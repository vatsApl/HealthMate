import 'package:clg_project/UI/widgets/custom_loader.dart';
import 'package:clg_project/constants.dart';
import 'package:flutter/material.dart';

class OutlinedBtn extends StatelessWidget {
  OutlinedBtn(
      {super.key, this.isLoading = false,
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
      height: 35.0,
      child: OutlinedButton(
        onPressed: () {
          onPressed!();
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        child: !isLoading
            ? Text(
                btnTitle,
                style: const TextStyle(
                    fontSize: 10.0,
                    color: kDefaultPurpleColor,
                    fontWeight: FontWeight.w500),
              )
            : CustomLoader(
                isVisible: isLoading,
                setColor: Colors.white,
              ),
      ),
    );
  }
}

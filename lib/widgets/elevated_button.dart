import 'package:clg_project/UI/widgets/custom_loader.dart';
import 'package:flutter/material.dart';

class ElevatedBtn extends StatelessWidget {
  ElevatedBtn(
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
      width: double.infinity,
      height: 44.0,
      child: ElevatedButton(
        onPressed: () {
          if(onPressed != null){
            onPressed!();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null ? bgColor : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        child: !isLoading
            ? Text(
                btnTitle,
                style: TextStyle(
                  fontSize: 16.0,
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

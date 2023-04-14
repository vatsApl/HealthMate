import 'package:clg_project/client_side/add_new_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../resourse/images.dart';

class CustomWidgetHelper {
  static appBar(
      {required BuildContext context,
      Color? appbarColor = Colors.white,
      Widget? action,
      Function? onActionTap}) {
    return AppBar(
      backgroundColor: appbarColor,
      elevation: 0.0,
      leading: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: SvgPicture.asset(
          Images.ic_left_arrow,
          fit: BoxFit.scaleDown,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: (){
            if(onActionTap != null){
              onActionTap();
            }
          },
          child: action ?? Container(),
        ),
      ],
    );
  }

  static Loader({required BuildContext context}) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

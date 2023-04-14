import 'package:clg_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardTopClient extends StatelessWidget {
  CardTopClient(
      {super.key,
      required this.icon,
      required this.number,
      required this.label,
      this.amountSymbol,
      this.icColor,
      this.onTap,
      });

  String icon;
  int number;
  String label;
  String? amountSymbol;
  Color? icColor;
  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: 160.0,
        height: 68.0,
        child: Card(
          elevation: 2.0,
          child: InkWell(
            onTap: (){
              if(onTap != null){
                onTap!();
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(
                left: 14.0,
                top: 14.0,
                bottom: 14.0,
                right: 14.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(amountSymbol ?? ''),
                          Text(
                            '$number',
                            style: const TextStyle(
                                fontSize: 16.0,
                                color: kDefaultBlackColor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        label,
                        style:
                            const TextStyle(color: klightColor, fontSize: 12.0),
                      ),
                    ],
                  ),
                  SvgPicture.asset(icon, color: icColor,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

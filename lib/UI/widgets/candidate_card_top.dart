import 'package:clg_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CardTopCandidate extends StatelessWidget {
  CardTopCandidate(
      {super.key,
      required this.icon,
      required this.number,
      required this.label,
      this.amountSymbol,
      this.onTap,
      });

  String icon;
  int number;
  String label;
  String? amountSymbol;
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
                        style: const TextStyle(
                          color: klightColor,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SvgPicture.asset(icon),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // return SizedBox(
    //   width: 80.0,
    //   height: 100.0,
    //   child: Card(
    //     elevation: 2.0,
    //     child: Column(
    //       children: [
    //         const SizedBox(height: 10.0,),
    //         SvgPicture.asset(icon),
    //         const SizedBox(height: 15.0,),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Text(amountSymbol ?? ''),
    //             Text('$number', style: const TextStyle(fontSize: 16.0, color: kDefaultBlackColor),),
    //           ],
    //         ),
    //         const SizedBox(height: 4.0,),
    //         Text(label, style: const TextStyle(color: klightColor),),
    //       ],
    //     ),
    //   ),
    // );
  }
}

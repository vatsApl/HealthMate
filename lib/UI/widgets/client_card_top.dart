import 'package:clg_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resourse/app_colors.dart';
import '../../resourse/dimens.dart';

class CardTopClient extends StatelessWidget {
  CardTopClient({
    super.key,
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
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$number',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: Dimens.pixel_16,
                        color: AppColors.kDefaultBlackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_5,
                    ),
                    Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        color: AppColors.klightColor,
                        fontSize: Dimens.pixel_12,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SvgPicture.asset(
                    icon,
                    color: icColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // return Card(
    //   elevation: Dimens.pixel_2,
    //   child: InkWell(
    //     onTap: () {
    //       if (onTap != null) {
    //         onTap!();
    //       }
    //     },
    //     child: Padding(
    //       padding: const EdgeInsets.all(
    //         Dimens.pixel_14,
    //       ),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Expanded(
    //             child: Column(
    //               // mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 Flexible(
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     children: [
    //                       Flexible(
    //                         child: Text(
    //                           '$number',
    //                           overflow: TextOverflow.ellipsis,
    //                           maxLines: 1,
    //                           style: const TextStyle(
    //                             fontSize: Dimens.pixel_16,
    //                             color: AppColors.kDefaultBlackColor,
    //                             fontWeight: FontWeight.w500,
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 const SizedBox(
    //                   height: Dimens.pixel_5,
    //                 ),
    //                 Flexible(
    //                   child: Text(
    //                     label,
    //                     overflow: TextOverflow.ellipsis,
    //                     maxLines: 1,
    //                     style: const TextStyle(
    //                       color: AppColors.klightColor,
    //                       fontSize: Dimens.pixel_12,
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Expanded(
    //             child: Align(
    //               alignment: Alignment.centerRight,
    //               child: SvgPicture.asset(
    //                 icon,
    //                 color: icColor,
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}

import 'package:clg_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resourse/app_colors.dart';
import '../../resourse/dimens.dart';

class CardTopCandidate extends StatelessWidget {
  CardTopCandidate({
    super.key,
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
    return SizedBox(
      width: Dimens.pixel_160,
      height: Dimens.pixel_68,
      child: Card(
        elevation: Dimens.pixel_2,
        child: InkWell(
          onTap: () {
            if (onTap != null) {
              onTap!();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(
              Dimens.pixel_14,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(amountSymbol ?? ''),
                            Flexible(
                              child: Text(
                                '$number',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: Dimens.pixel_16,
                                  color: AppColors.kDefaultBlackColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Dimens.pixel_5,
                      ),
                      Flexible(
                        child: Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            color: AppColors.klightColor,
                            fontSize: Dimens.pixel_12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: SvgPicture.asset(icon),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

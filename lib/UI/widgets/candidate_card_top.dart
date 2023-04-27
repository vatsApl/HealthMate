import 'package:clg_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      width: 160.0,
      height: 68.0,
      child: Card(
        elevation: 2.0,
        child: InkWell(
          onTap: () {
            if (onTap != null) {
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
                                  fontSize: 16.0,
                                  color: kDefaultBlackColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Flexible(
                        child: Text(
                          label,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            color: klightColor,
                            fontSize: 12.0,
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

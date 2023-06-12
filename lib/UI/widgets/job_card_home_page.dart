import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/candidate_side/find_job/model/find_job_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resourse/app_colors.dart';
import '../../resourse/dimens.dart';

class JobCardCandidate extends StatelessWidget {
  JobModel? homePageModel;
  int? currentIndex;
  JobCardCandidate({this.homePageModel, this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.pixel_6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          Dimens.pixel_16,
          Dimens.pixel_16,
          Dimens.pixel_16,
          Dimens.pixel_18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimens.pixel_8,
                  ),
                  child: Text(
                    '${homePageModel?.jobCategory}'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: Dimens.pixel_10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.kDefaultPurpleColor,
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: Dimens.pixel_16,
                      color: AppColors.kDefaultPurpleColor,
                    ),
                    children: <TextSpan>[
                      const TextSpan(
                        text: Strings.amount_symbol_rupee,
                        style: TextStyle(
                          fontSize: Dimens.pixel_16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.kDefaultBlackColor,
                        ),
                      ),
                      TextSpan(
                        text: '${homePageModel?.jobSalary}',
                        style: const TextStyle(
                          fontSize: Dimens.pixel_16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.kDefaultBlackColor,
                        ),
                      ),
                      const TextSpan(
                        text: Strings.text_per_day,
                        style: TextStyle(
                          fontSize: Dimens.pixel_12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.klightColor,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: Dimens.pixel_10,
            ),
            Text(
              "${homePageModel?.jobTitle}",
              style: const TextStyle(
                color: AppColors.kDefaultBlackColor,
                fontSize: Dimens.pixel_16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: Dimens.pixel_10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      Images.ic_location,
                      fit: BoxFit.scaleDown,
                    ), //
                    const SizedBox(
                      width: Dimens.pixel_8,
                    ),
                    Text(
                      '${homePageModel?.jobLocation}',
                      style: const TextStyle(
                        fontSize: Dimens.pixel_12,
                        color: Color(0xff656565),
                      ),
                    ),
                  ],
                ),
                currentIndex == 2
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimens.pixel_6,
                          horizontal: Dimens.pixel_8,
                        ),
                        decoration: BoxDecoration(
                          color: homePageModel?.workingStatus ==
                                  Strings
                                      .text_payment_due //color change with timeSheetstatusType
                              ? AppColors.kYellowColor.withOpacity(0.1)
                              : homePageModel?.workingStatus ==
                                      Strings.text_worked
                                  ? AppColors.kTealColor.withOpacity(0.2)
                                  : homePageModel?.workingStatus ==
                                          Strings.text_paid
                                      ? AppColors.kGreenColor.withOpacity(0.1)
                                      : homePageModel?.workingStatus ==
                                              Strings.text_dispute
                                          ? AppColors.kredColor.withOpacity(0.1)
                                          : null,
                          borderRadius: BorderRadius.circular(Dimens.pixel_4),
                        ),
                        child: Text(
                          '${homePageModel?.workingStatus}',
                          style: TextStyle(
                            fontSize: Dimens.pixel_10,
                            color: homePageModel?.workingStatus ==
                                    Strings
                                        .text_payment_due //color change with timeSheetstatusType
                                ? AppColors.kredColor
                                : homePageModel?.workingStatus ==
                                        Strings.text_worked
                                    ? AppColors.kDefaultBlackColor
                                    : homePageModel?.workingStatus ==
                                            Strings.text_paid
                                        ? AppColors.kGreenColor
                                        : homePageModel?.workingStatus ==
                                                Strings.text_dispute
                                            ? AppColors.kredColor
                                            : null,
                          ),
                        ),
                      )
                    : SvgPicture.asset(
                        Images.ic_read_more,
                        fit: BoxFit.scaleDown,
                      ),
              ],
            ),
            const SizedBox(
              height: Dimens.pixel_10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        Images.ic_calander,
                        color: AppColors.kDefaultPurpleColor,
                        fit: BoxFit.scaleDown,
                      ),
                      const SizedBox(
                        width: Dimens.pixel_8,
                      ),
                      Text(
                        homePageModel?.jobDate ?? '',
                        style: const TextStyle(
                          color: AppColors.kDefaultPurpleColor,
                          fontWeight: FontWeight.w500,
                          fontSize: Dimens.pixel_13,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      Images.ic_clock,
                      fit: BoxFit.scaleDown,
                    ),
                    const SizedBox(
                      width: Dimens.pixel_8,
                    ),
                    Text(
                      '${homePageModel?.jobStartTime} - ${homePageModel?.jobEndTime}',
                      style: const TextStyle(
                        fontSize: Dimens.pixel_12,
                        color: AppColors.klabelColor,
                      ),
                    ),
                  ],
                ),
                const Text(
                  '',
                  style: TextStyle(
                    fontSize: Dimens.pixel_10,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

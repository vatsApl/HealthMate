import 'package:clg_project/constants.dart';
import 'package:clg_project/models/candidate_models/find_job_response.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resourse/dimens.dart';
import '../../resourse/strings.dart';

class JobCardWithStatus extends StatefulWidget {
  JobModel? jobModel;
  JobCardWithStatus({super.key, this.jobModel});

  @override
  State<JobCardWithStatus> createState() => _JobCardWithStatusState();
}

class _JobCardWithStatusState extends State<JobCardWithStatus> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: Dimens.pixel_2,
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
                    '${widget.jobModel?.jobCategory}'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: Dimens.pixel_10,
                      fontWeight: FontWeight.w500,
                      color: kDefaultPurpleColor,
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                      style: const TextStyle(
                        fontSize: Dimens.pixel_16,
                        color: kDefaultPurpleColor,
                      ),
                      children: <TextSpan>[
                        const TextSpan(
                          text: Strings.amount_symbol_rupee,
                          style: TextStyle(
                            fontSize: Dimens.pixel_16,
                            fontWeight: FontWeight.w500,
                            color: kDefaultBlackColor,
                          ),
                        ),
                        TextSpan(
                          text: '${widget.jobModel?.jobSalary}',
                          style: const TextStyle(
                            fontSize: Dimens.pixel_16,
                            fontWeight: FontWeight.w500,
                            color: kDefaultBlackColor,
                          ),
                        ),
                        const TextSpan(
                          text: Strings.text_per_day,
                          style: TextStyle(
                            fontSize: Dimens.pixel_12,
                            fontWeight: FontWeight.w400,
                            color: klightColor,
                          ),
                        ),
                      ]),
                )
              ],
            ),
            const SizedBox(
              height: Dimens.pixel_10,
            ),
            Text(
              "${widget.jobModel?.jobTitle}",
              style: const TextStyle(
                color: kDefaultBlackColor,
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
                      '${widget.jobModel?.jobLocation}',
                      style: const TextStyle(
                        fontSize: Dimens.pixel_12,
                        color: Color(0xff656565),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimens.pixel_6,
                    horizontal: Dimens.pixel_8,
                  ),
                  decoration: BoxDecoration(
                    color: widget.jobModel?.jobStatus ==
                            Strings
                                .text_assigned //color change with timeSheetstatusType
                        ? kGreenColor.withOpacity(0.1)
                        : widget.jobModel?.jobStatus == Strings.text_pending
                            ? kYellowColor.withOpacity(0.1)
                            : widget.jobModel?.jobStatus == Strings.text_dispute
                                ? kredColor.withOpacity(0.1)
                                : widget.jobModel?.jobStatus ==
                                        Strings.text_processing
                                    ? kYellowColor.withOpacity(0.1)
                                    : widget.jobModel?.jobStatus ==
                                            Strings.text_paid
                                        ? kGreenColor.withOpacity(0.1)
                                        : null,
                    borderRadius: BorderRadius.circular(
                      Dimens.pixel_4,
                    ),
                  ),
                  child: Text(
                    '${widget.jobModel?.jobStatus}',
                    style: TextStyle(
                      fontSize: Dimens.pixel_10,
                      color: widget.jobModel?.jobStatus ==
                              Strings
                                  .text_assigned //color change with timeSheetstatusType
                          ? kGreenColor
                          : widget.jobModel?.jobStatus == Strings.text_pending
                              ? kYellowColor
                              : widget.jobModel?.jobStatus ==
                                      Strings.text_dispute
                                  ? kredColor
                                  : widget.jobModel?.jobStatus ==
                                          Strings.text_processing
                                      ? kYellowColor
                                      : widget.jobModel?.jobStatus ==
                                              Strings.text_paid
                                          ? kGreenColor
                                          : null,
                    ),
                  ),
                ),
              ],
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
                      Images.ic_calander,
                      color: kDefaultPurpleColor,
                      fit: BoxFit.scaleDown,
                    ),
                    const SizedBox(
                      width: Dimens.pixel_8,
                    ),
                    Text(
                      widget.jobModel?.jobDate ?? '',
                      style: const TextStyle(
                        color: kDefaultPurpleColor,
                        fontWeight: FontWeight.w500,
                        fontSize: Dimens.pixel_13,
                      ),
                    ),
                  ],
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
                      '${widget.jobModel?.jobStartTime} - ${widget.jobModel?.jobEndTime}',
                      style: const TextStyle(
                        fontSize: Dimens.pixel_12,
                        color: Color(0xff656565),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

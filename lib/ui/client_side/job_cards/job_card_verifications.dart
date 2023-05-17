import 'package:cached_network_image/cached_network_image.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/candidate_models/find_job_response.dart';
import 'package:clg_project/resourse/dimens.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../allAPIs/allAPIs.dart';
import '../../../resourse/app_colors.dart';

class JobCardVerification extends StatefulWidget {
  JobModel? jobModel;
  JobCardVerification({this.jobModel});

  @override
  State<JobCardVerification> createState() => _JobCardVerificationState();
}

class _JobCardVerificationState extends State<JobCardVerification> {
  Candidates? candidatesModel;
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
                    '${widget.jobModel?.jobCategory}'.toUpperCase(),
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
                        text: '${widget.jobModel?.jobSalary}',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.jobModel?.jobTitle}",
                  style: const TextStyle(
                    color: AppColors.kDefaultBlackColor,
                    fontSize: Dimens.pixel_16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SvgPicture.asset(
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
                Row(
                  children: [
                    SvgPicture.asset(
                      Images.ic_location,
                      fit: BoxFit.scaleDown,
                    ),
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
              ],
            ),
            const SizedBox(
              height: Dimens.pixel_12_point_67,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
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
                            widget.jobModel?.jobDate ?? '',
                            style: const TextStyle(
                              color: AppColors.kDefaultPurpleColor,
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
                ),
              ],
            ),
            const SizedBox(
              height: Dimens.pixel_12_and_half,
            ),
            Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: Dimens.pixel_20,
                  child: Stack(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.jobModel?.candidates?.length,
                        itemBuilder: (BuildContext context, int index) {
                          String? netImg =
                              widget.jobModel?.candidates?[index].avatar;
                          return Align(
                            widthFactor: Dimens.pixel_0_point_6,
                            child: SizedBox(
                              height: Dimens.pixel_20,
                              width: Dimens.pixel_20,
                              child: CachedNetworkImage(
                                imageUrl: '${DataURL.baseUrl}/$netImg',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => CircleAvatar(
                                  child: SvgPicture.asset(
                                    Images.ic_person,
                                    color: Colors.white,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  child: SvgPicture.asset(
                                    Images.ic_person,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                if (widget.jobModel?.extraCount != 0)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: Dimens.pixel_6,
                    ),
                    child: Text(
                      '+${widget.jobModel?.extraCount}',
                      style: const TextStyle(
                        fontSize: Dimens.pixel_10,
                        fontWeight: FontWeight.w400,
                        color: AppColors.kDefaultBlackColor,
                      ),
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

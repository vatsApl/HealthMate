import 'package:cached_network_image/cached_network_image.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/candidate_models/find_job_response.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../allAPIs/allAPIs.dart';

class JobCardVerification extends StatefulWidget {
  JobModel? jobModel;
  // int? indexNumer;
  JobCardVerification({this.jobModel});

  @override
  State<JobCardVerification> createState() => _JobCardVerificationState();
}

class _JobCardVerificationState extends State<JobCardVerification> {
  Candidates? candidatesModel;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    '${widget.jobModel?.jobCategory}'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w500,
                      color: kDefaultPurpleColor,
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 16.0, color: kDefaultPurpleColor),
                    children: <TextSpan>[
                      const TextSpan(
                        text: '₹ ',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          color: kDefaultBlackColor,
                        ),
                      ),
                      TextSpan(
                          text: '${widget.jobModel?.jobSalary}',
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            color: kDefaultBlackColor,
                          ),
                      ),
                      const TextSpan(
                          text: '/day',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w400,
                              color: klightColor,
                          ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.jobModel?.jobTitle}",
                  style: const TextStyle(
                      color: kDefaultBlackColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                ),
                SvgPicture.asset(
                  Images.ic_read_more,
                  fit: BoxFit.scaleDown,
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
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
                      width: 8.0,
                    ),
                    Text(
                      '${widget.jobModel?.jobLocation}',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Color(0xff656565),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 12.67,
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
                            color: kDefaultPurpleColor,
                            fit: BoxFit.scaleDown,
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            widget.jobModel?.jobDate ?? '',
                            style: const TextStyle(
                              color: kDefaultPurpleColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 13.0,
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
                            width: 8.0,
                          ),
                          Text(
                            '${widget.jobModel?.jobStartTime} - ${widget.jobModel?.jobEndTime}',
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Color(0xff656565),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // const Text('', style: TextStyle(fontSize: 10.0, color: Colors.red),),
              ],
            ),
            const SizedBox(
              height: 12.5,
            ),
            // const Text(
            //   'Candidates',
            //   style: TextStyle(
            //       color: kDefaultPurpleColor,
            //       fontWeight: FontWeight.w400,
            //       fontSize: 10.0),
            // ),
            // const SizedBox(
            //   height: 5.0,
            // ),
            Row(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 20.0,
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
                            widthFactor: 0.6,
                            child: SizedBox(
                              height: 20.0,
                              width: 20.0,
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
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Text(
                      '+${widget.jobModel?.extraCount}',
                      style: const TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w400,
                        color: kDefaultBlackColor,
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

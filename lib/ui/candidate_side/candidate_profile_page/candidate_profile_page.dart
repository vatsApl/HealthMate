import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/candidate_side/candidate_profile_page/candidate_personal_details/view/candidate_personal_details.dart';
import 'package:clg_project/ui/candidate_side/candidate_profile_page/cv_and_resume/view/cv_resume.dart';
import 'package:clg_project/ui/candidate_side/candidate_profile_page/role_and_skills/view/role_skills.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:provider/provider.dart';

import '../../../UI/widgets/custom_appbar.dart';
import '../../../methods/methods.dart';
import '../../../resourse/app_colors.dart';
import '../../../resourse/dimens.dart';

class CandidateProfilePage extends StatefulWidget {
  @override
  State<CandidateProfilePage> createState() => _CandidateProfilePageState();
}

class _CandidateProfilePageState extends State<CandidateProfilePage> {
  bool isVisible = false;
  String? uFirstName;
  String? uRoleName;
  String? netImg;

  getData() {
    setState(() {
      uFirstName =
          PreferencesHelper.getString(PreferencesHelper.KEY_FIRST_NAME);
      uRoleName = PreferencesHelper.getString(PreferencesHelper.KEY_ROLE_NAME);
      netImg = PreferencesHelper.getString(PreferencesHelper.KEY_AVATAR);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ValueNotifier<int>>(context, listen: false).value = 0;
        return false;
      },
      child: FocusDetector(
        onFocusGained: () {
          getData();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            name: uFirstName,
            role: uRoleName,
            // svgPictureTrailing: Images.ic_notification,
            netImg: netImg,
          ),
          body: Container(
            padding: const EdgeInsets.fromLTRB(
              Dimens.pixel_16,
              Dimens.pixel_19,
              Dimens.pixel_16,
              Dimens.pixel_0,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: Dimens.pixel_48,
                ),
                child: Column(
                  children: [
                    // Previous used instead of app bar
                    // Row(
                    //   children: [
                    //     SizedBox(
                    //       width: Dimens.pixel_55,
                    //       height: Dimens.pixel_55,
                    //       child: Container(
                    //         decoration: const BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           color: AppColors.kDefaultPurpleColor,
                    //         ),
                    //         child: CircleAvatar(
                    //           child: CachedNetworkImage(
                    //             imageUrl: '${DataURL.baseUrl}/${netImg ?? ''}',
                    //             imageBuilder: (context, imageProvider) => Container(
                    //               decoration: BoxDecoration(
                    //                 shape: BoxShape.circle,
                    //                 image: DecorationImage(
                    //                   image: imageProvider,
                    //                   fit: BoxFit.cover,
                    //                 ),
                    //               ),
                    //             ),
                    //             placeholder: (context, url) => CircleAvatar(
                    //               child: SvgPicture.asset(
                    //                 Images.ic_person,
                    //                 color: Colors.white,
                    //                 height: Dimens.pixel_35,
                    //               ),
                    //             ),
                    //             errorWidget: (context, url, error) => CircleAvatar(
                    //               child: SvgPicture.asset(
                    //                 Images.ic_person,
                    //                 color: Colors.white,
                    //                 height: Dimens.pixel_35,
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: Dimens.pixel_14,
                    //     ),
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           uFirstName ?? '',
                    //           style: const TextStyle(
                    //             color: AppColors.kDefaultPurpleColor,
                    //             fontSize: Dimens.pixel_18,
                    //             fontWeight: FontWeight.w700,
                    //           ),
                    //         ),
                    //         Text(
                    //           uRoleName ?? '',
                    //           style: const TextStyle(
                    //             color: AppColors.kDefaultBlackColor,
                    //             height: Dimens.pixel_1_point_2,
                    //           ),
                    //         ),
                    //       ],
                    //     )
                    //   ],
                    // ),
                    Column(
                      children: [
                        Container(
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CandidatePersonalDetails(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimens.pixel_4,
                              ),
                              child: ListTile(
                                leading: SvgPicture.asset(
                                  Images.ic_personal_details,
                                  color: AppColors.kDefaultPurpleColor,
                                ),
                                title: const Text(
                                  Strings.text_personal_details,
                                  style: TextStyle(
                                    color: AppColors.kDefaultBlackColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                trailing: SvgPicture.asset(
                                  Images.ic_read_more_1,
                                  color: AppColors.kreadMoreColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: Dimens.pixel_18,
                        ),
                        Container(
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RoleAndSkills(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimens.pixel_4,
                              ),
                              child: ListTile(
                                leading: SvgPicture.asset(
                                  Images.ic_skills,
                                  color: AppColors.kDefaultPurpleColor,
                                ),
                                title: const Text(
                                  Strings.text_role_and_skills,
                                  style: TextStyle(
                                    color: AppColors.kDefaultBlackColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                trailing: SvgPicture.asset(
                                  Images.ic_read_more_1,
                                  color: AppColors.kreadMoreColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: Dimens.pixel_18,
                        ),
                        Container(
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CvResume(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimens.pixel_4),
                              child: ListTile(
                                leading: SvgPicture.asset(
                                  Images.ic_resume,
                                  color: AppColors.kDefaultPurpleColor,
                                ),
                                title: const Text(
                                  Strings.text_cv_and_resume,
                                  style: TextStyle(
                                    color: AppColors.kDefaultBlackColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                trailing: SvgPicture.asset(
                                  Images.ic_read_more_1,
                                  color: AppColors.kreadMoreColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: Dimens.pixel_18,
                        ),
                        Container(
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              // this navigation will start when next screen created:
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const SettingsPage(),
                              //   ),
                              // );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Dimens.pixel_4),
                              child: ListTile(
                                leading: SvgPicture.asset(
                                  Images.ic_settings,
                                  color: AppColors.kDefaultPurpleColor,
                                ),
                                title: const Text(
                                  Strings.text_settings,
                                  style: TextStyle(
                                    color: AppColors.kDefaultBlackColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                trailing: SvgPicture.asset(
                                  Images.ic_read_more_1,
                                  color: AppColors.kreadMoreColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: Dimens.pixel_18,
                        ),
                        Container(
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: () {
                              Methods.showDialogLogOut(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: Dimens.pixel_4,
                              ),
                              child: ListTile(
                                leading: SvgPicture.asset(
                                  Images.ic_logout,
                                  color: AppColors.kDefaultPurpleColor,
                                ),
                                title: const Text(
                                  Strings.text_log_out,
                                  style: TextStyle(
                                    color: AppColors.kDefaultBlackColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                trailing: SvgPicture.asset(
                                  Images.ic_read_more_1,
                                  color: AppColors.kreadMoreColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

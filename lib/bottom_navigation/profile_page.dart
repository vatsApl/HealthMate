import 'package:cached_network_image/cached_network_image.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/bottom_navigation/profile/cv_resume.dart';
import 'package:clg_project/bottom_navigation/profile/personal_details.dart';
import 'package:clg_project/bottom_navigation/profile/role_skills.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import '../methods/methods.dart';
import '../resourse/dimens.dart';

class ProfilePage extends StatefulWidget {

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    return FocusDetector(
      onFocusGained: () {
        getData();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(Dimens.pixel_16, Dimens.pixel_63, Dimens.pixel_16, Dimens.pixel_0,),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: Dimens.pixel_55,
                      height: Dimens.pixel_55,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: kDefaultPurpleColor,
                        ),
                        child: CircleAvatar(
                          child: CachedNetworkImage(
                            imageUrl: '${DataURL.baseUrl}/${netImg ?? ''}',
                            imageBuilder: (context, imageProvider) => Container(
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
                                height: Dimens.pixel_35,
                              ),
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              child: SvgPicture.asset(
                                Images.ic_person,
                                color: Colors.white,
                                height: Dimens.pixel_35,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: Dimens.pixel_14,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          uFirstName ?? '',
                          style: const TextStyle(
                            color: kDefaultPurpleColor,
                            fontSize: Dimens.pixel_18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          uRoleName ?? '',
                          style: const TextStyle(
                              color: kDefaultBlackColor, height: Dimens.pixel_1_point_2,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: Dimens.pixel_48,
                ),
                Column(
                  children: [
                    Card(
                      elevation: Dimens.pixel_2,
                      shadowColor: const Color(0xff000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimens.pixel_6),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PersonalDetails(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimens.pixel_4),
                          child: ListTile(
                            leading: SvgPicture.asset(
                              Images.ic_personal_details,
                              color: kDefaultPurpleColor,
                            ),
                            title: const Text(
                              Strings.text_personal_details,
                              style: TextStyle(
                                color: kDefaultBlackColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: SvgPicture.asset(
                              Images.ic_read_more_1,
                              color: kreadMoreColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_18,
                    ),
                    Card(
                      elevation: Dimens.pixel_2,
                      shadowColor: const Color(0xff000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimens.pixel_6),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RoleSkills(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimens.pixel_4),
                          child: ListTile(
                            leading: SvgPicture.asset(
                              Images.ic_skills,
                              color: kDefaultPurpleColor,
                            ),
                            title: const Text(
                              Strings.text_role_and_skills,
                              style: TextStyle(
                                color: kDefaultBlackColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: SvgPicture.asset(
                              Images.ic_read_more_1,
                              color: kreadMoreColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_18,
                    ),
                    Card(
                      elevation: Dimens.pixel_2,
                      shadowColor: const Color(0xff000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimens.pixel_6),
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
                          padding: const EdgeInsets.symmetric(vertical: Dimens.pixel_4),
                          child: ListTile(
                            leading: SvgPicture.asset(
                              Images.ic_resume,
                              color: kDefaultPurpleColor,
                            ),
                            title: const Text(
                              Strings.text_cv_and_resume,
                              style: TextStyle(
                                color: kDefaultBlackColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: SvgPicture.asset(
                              Images.ic_read_more_1,
                              color: kreadMoreColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_18,
                    ),
                    Card(
                      elevation: Dimens.pixel_2,
                      shadowColor: const Color(0xff000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimens.pixel_6),
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
                          padding: const EdgeInsets.symmetric(vertical: Dimens.pixel_4),
                          child: ListTile(
                            leading: SvgPicture.asset(
                              Images.ic_settings,
                              color: kDefaultPurpleColor,
                            ),
                            title: const Text(
                              Strings.text_settings,
                              style: TextStyle(
                                color: kDefaultBlackColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: SvgPicture.asset(
                              Images.ic_read_more_1,
                              color: kreadMoreColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_18,
                    ),
                    Card(
                      elevation: Dimens.pixel_2,
                      shadowColor: const Color(0xff000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimens.pixel_6),
                      ),
                      child: InkWell(
                        onTap: () {
                          Methods.showDialogLogOut(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Dimens.pixel_4,),
                          child: ListTile(
                            leading: SvgPicture.asset(
                              Images.ic_logout,
                              color: kDefaultPurpleColor,
                            ),
                            title: const Text(
                              Strings.text_log_out,
                              style: TextStyle(
                                color: kDefaultBlackColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            trailing: SvgPicture.asset(
                              Images.ic_read_more_1,
                              color: kreadMoreColor,
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
    );
  }
}

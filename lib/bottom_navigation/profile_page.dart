import 'package:cached_network_image/cached_network_image.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/bottom_navigation/profile/cv_resume.dart';
import 'package:clg_project/bottom_navigation/profile/personal_details.dart';
import 'package:clg_project/bottom_navigation/profile/role_skills.dart';
import 'package:clg_project/bottom_navigation/profile/settings_page.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';

import '../methods/methods.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
      uFirstName = PreferencesHelper.getString(PreferencesHelper.KEY_FIRST_NAME);
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
          padding: const EdgeInsets.fromLTRB(16.0, 63.0, 16.0, 0.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 55.0,
                      height: 55.0,
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
                                height: 35.0,
                              ),
                            ),
                            errorWidget: (context, url, error) => CircleAvatar(
                              child: SvgPicture.asset(
                                Images.ic_person,
                                color: Colors.white,
                                height: 35.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 14.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          uFirstName ?? '',
                          style: const TextStyle(
                            color: kDefaultPurpleColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          uRoleName ?? '',
                          style: const TextStyle(
                              color: kDefaultBlackColor, height: 1.2),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 48.0,
                ),
                Column(
                  children: [
                    Card(
                      elevation: 2.0,
                      shadowColor: const Color(0xff000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PersonalDetails()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            leading: SvgPicture.asset(
                              Images.ic_personal_details,
                              color: kDefaultPurpleColor,
                            ),
                            title: const Text(
                              'Personal details',
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
                      height: 18.0,
                    ),
                    Card(
                      elevation: 2.0,
                      shadowColor: const Color(0xff000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RoleSkills(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            leading: SvgPicture.asset(
                              Images.ic_skills,
                              color: kDefaultPurpleColor,
                            ),
                            title: const Text(
                              'Role & Skills',
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
                        height: 18.0,
                    ),
                    Card(
                      elevation: 2.0,
                      shadowColor: const Color(0xff000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CvResume(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            leading: SvgPicture.asset(
                              Images.ic_resume,
                              color: kDefaultPurpleColor,
                            ),
                            title: const Text(
                              'CV & Resume',
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
                      height: 18.0,
                    ),
                    Card(
                      elevation: 2.0,
                      shadowColor: const Color(0xff000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const SettingsPage(),
                          //   ),
                          // );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            leading: SvgPicture.asset(
                              Images.ic_settings,
                              color: kDefaultPurpleColor,
                            ),
                            title: const Text(
                              'Settings',
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
                      height: 18.0,
                    ),
                    Card(
                      elevation: 2.0,
                      shadowColor: const Color(0xff000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Methods.showDialogLogOut(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            leading: SvgPicture.asset(
                              Images.ic_logout,
                              color: kDefaultPurpleColor,
                            ),
                            title: const Text(
                              'Log Out',
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

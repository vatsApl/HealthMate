import 'package:cached_network_image/cached_network_image.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/bottom_navigation/profile/cv_resume.dart';
import 'package:clg_project/bottom_navigation/profile/personal_details.dart';
import 'package:clg_project/bottom_navigation/profile/role_skills.dart';
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
  var uFirstName;
  var uRoleName;
  String? netImg;

  getData() {
    uFirstName = PreferencesHelper.getString(PreferencesHelper.KEY_FIRST_NAME);
    uRoleName = PreferencesHelper.getString(PreferencesHelper.KEY_ROLE_NAME);
    // var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
    netImg = PreferencesHelper.getString(PreferencesHelper.KEY_AVATAR);
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
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 40.0, 16.0, 0.0),
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
                                height: 30.0,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                CircleAvatar(
                                  child: SvgPicture.asset(
                                    Images.ic_person,
                                    color: Colors.white,
                                    height: 30.0,
                                  ),
                                ),
                          ),
                          // child: netImg == 'null'
                          //     ? SvgPicture.asset(
                          //         Images.ic_person,
                          //         color: Colors.white,
                          //         height: 30.0,
                          //       )
                          //     : Container(
                          //         decoration: BoxDecoration(
                          //           shape: BoxShape.circle,
                          //           image: DecorationImage(
                          //             image: NetworkImage(
                          //                 '${DataURL.baseUrl}/$netImg'),
                          //             fit: BoxFit.cover,
                          //           ),
                          //         ),
                          //       ),
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
                          uFirstName,
                          style: const TextStyle(
                            color: kDefaultPurpleColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          uRoleName,
                          style: const TextStyle(
                              color: kDefaultBlackColor, height: 1.2),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 40.0,
                ),
                Column(
                  children: [
                    Card(
                      elevation: 1.0,
                      shadowColor: const Color(0xff000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PersonalDetails()));
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
                    const SizedBox(height: 12.0,),
                    Card(
                      elevation: 1.0,
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
                    const SizedBox(height: 12.0,),
                    Card(
                      elevation: 1.0,
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
                    const SizedBox(height: 12.0,),
                    Card(
                      elevation: 1.0,
                      shadowColor: const Color(0xff000000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
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
                    const SizedBox(height: 12.0,),
                    Card(
                      elevation: 1.0,
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

  // Future<dynamic> buildShowLogOutDialog(BuildContext context) {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(6.0),
  //         ),
  //         child: Wrap(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.symmetric(
  //                   horizontal: 10.0, vertical: 25.0),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   const SizedBox(
  //                     height: 12.0,
  //                   ),
  //                   SvgPicture.asset(
  //                     Images.ic_personal_details,
  //                     // fit: BoxFit.scaleDown,
  //                     height: 40.0,
  //                     width: 40.0,
  //                     color: kredColor,
  //                   ),
  //                   const SizedBox(
  //                     height: 20.0,
  //                   ),
  //                   const Text(
  //                     'Log Out!',
  //                     style: TextStyle(
  //                       fontSize: 18.0,
  //                       fontWeight: FontWeight.w700,
  //                       color: kredColor,
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 12.0,
  //                   ),
  //                   Text(
  //                     'Are You Sure You Want To Log Out?',
  //                     style: const TextStyle(color: kDefaultBlackColor)
  //                         .copyWith(height: 1.5),
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   const SizedBox(
  //                     height: 30.0,
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       SizedBox(
  //                         width: 110.0,
  //                         height: 44.0,
  //                         child: ElevatedButton(
  //                             style: ElevatedButton.styleFrom(
  //                               backgroundColor: kredColor,
  //                             ),
  //                             onPressed: () async {
  //                               PreferencesHelper.setBool(PreferencesHelper.KEY_USER_LOGIN, false);
  //                               Navigator.of(context).pushAndRemoveUntil(
  //                                   MaterialPageRoute(
  //                                     builder: (context) => const SignInPage(),
  //                                   ),
  //                                   (route) => false);
  //                             },
  //                             child: const Text(
  //                               'Logout',
  //                               style: TextStyle(
  //                                 fontSize: 16.0,
  //                                 fontWeight: FontWeight.w500,
  //                               ),
  //                             )),
  //                       ),
  //                       const SizedBox(
  //                         width: 17.0,
  //                       ),
  //                       SizedBox(
  //                         width: 110.0,
  //                         height: 44.0,
  //                         child: ElevatedButton(
  //                             style: ElevatedButton.styleFrom(
  //                               backgroundColor: klightColor,
  //                             ),
  //                             onPressed: () {
  //                               Navigator.pop(context);
  //                             },
  //                             child: const Text(
  //                               'Cancel',
  //                               style: TextStyle(
  //                                 fontSize: 16.0,
  //                                 fontWeight: FontWeight.w500,
  //                               ),
  //                             )),
  //                       ),
  //                     ],
  //                   )
  //                   // Align(
  //                   //   alignment: Alignment.center,
  //                   //   child: ElevatedBtn(
  //                   //       btnTitle: 'Okay !',
  //                   //       onPressed: () {
  //                   //         Navigator.pop(context);
  //                   //       }),
  //                   // ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}

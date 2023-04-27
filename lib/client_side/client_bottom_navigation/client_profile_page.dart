import 'package:clg_project/UI/widgets/custom_appbar.dart';
import 'package:clg_project/client_side/client_addresses.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import '../../constants.dart';
import '../../methods/methods.dart';
import '../../resourse/dimens.dart';
import '../../resourse/images.dart';
import '../client_personal_details.dart';

class ClientProfilePage extends StatefulWidget {
  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  var clientName;
  String? netImg;

  void getData() {
    setState(() {
      clientName =
          PreferencesHelper.getString(PreferencesHelper.KEY_CLIENT_NAME);
      netImg = PreferencesHelper.getString(PreferencesHelper.KEY_CLIENT_AVATAR);
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimens.pixel_16,
        Dimens.pixel_19,
        Dimens.pixel_16,
        Dimens.pixel_0,
      ),
      child: FocusDetector(
        onFocusGained: () {
          getData();
        },
        child: Scaffold(
          appBar: CustomAppBar(
            name: clientName,
            netImg: netImg,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: Dimens.pixel_48,
              ),
              child: Column(
                children: [
                  Card(
                    elevation: Dimens.pixel_2,
                    shadowColor: const Color(0xff000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Dimens.pixel_6,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClientPersonalDetails(),
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
                    height: Dimens.pixel_12,
                  ),
                  Card(
                    elevation: Dimens.pixel_2,
                    shadowColor: const Color(0xff000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Dimens.pixel_6,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClientAddresses(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimens.pixel_4,
                        ),
                        child: ListTile(
                          leading: SvgPicture.asset(
                            Images.ic_hospital,
                            color: kDefaultPurpleColor,
                          ),
                          title: const Text(
                            Strings.text_addresses,
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
                    height: Dimens.pixel_12,
                  ),
                  Card(
                    elevation: Dimens.pixel_2,
                    shadowColor: const Color(0xff000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Dimens.pixel_6,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimens.pixel_4,
                      ),
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
                  const SizedBox(
                    height: Dimens.pixel_12,
                  ),
                  Card(
                    elevation: Dimens.pixel_2,
                    shadowColor: const Color(0xff000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Dimens.pixel_6,
                      ),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}

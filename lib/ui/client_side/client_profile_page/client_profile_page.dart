import 'package:clg_project/UI/widgets/custom_appbar.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:provider/provider.dart';
import '../../../MyFirebaseService.dart';
import '../../../methods/methods.dart';
import '../../../resourse/app_colors.dart';
import '../../../resourse/dimens.dart';
import '../../../resourse/images.dart';
import 'client_addresses/view/client_addresses.dart';
import 'client_personal_details/view/client_personal_details.dart';

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

  getAnalytics() async {
    // google analytics
    await MyFirebaseService.logScreen('client profile screen');
  }

  @override
  void initState() {
    super.initState();
    getData();
    getAnalytics();
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
            name: clientName,
            netImg: netImg,
          ),
          body: Container(
            padding: const EdgeInsets.fromLTRB(
              Dimens.pixel_16,
              Dimens.pixel_19,
              Dimens.pixel_16,
              Dimens.pixel_0,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: Dimens.pixel_48,
                ),
                child: Column(
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
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
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
                      height: Dimens.pixel_12,
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
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
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
                              color: AppColors.kDefaultPurpleColor,
                            ),
                            title: const Text(
                              Strings.text_addresses,
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
                      height: Dimens.pixel_12,
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
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: Dimens.pixel_4,
                        ),
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
                    const SizedBox(
                      height: Dimens.pixel_12,
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
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Methods.showDialogLogOut(
                              context: context, isClient: true);
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
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

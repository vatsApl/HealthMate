import 'package:clg_project/UI/widgets/custom_appbar.dart';
import 'package:clg_project/client_side/client_addresses.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants.dart';
import '../../methods/methods.dart';
import '../../resourse/images.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({Key? key}) : super(key: key);

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {

  var clientName = PreferencesHelper.getString(PreferencesHelper.KEY_CLIENT_NAME);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 19.0, 16.0, 0.0),
      child: Scaffold(
        appBar: CustomAppBar(name: clientName,),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 48.0),
            child: Column(
              children: [
                Card(
                  elevation: 1.0,
                  shadowColor: const Color(0xff000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => PersonalDetails(),),);
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
                              builder: (context) => const ClientAddresses(),
                          ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        leading: SvgPicture.asset(
                          Images.ic_hospital,
                          color: kDefaultPurpleColor,
                        ),
                        title: const Text(
                          'Addresses',
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
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:clg_project/helper/socket_io_client.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../resourse/app_colors.dart';
import '../../resourse/dimens.dart';
import '../message/view/message_list_page.dart';
import 'client_contract_page/view/client_contract_page.dart';
import 'client_home_page/view/client_home_page.dart';
import 'client_profile_page/client_profile_page.dart';
import 'client_verification_pages/client_verification_page.dart';

class ClientMainPage extends StatefulWidget {
  @override
  State<ClientMainPage> createState() => _ClientMainPageState();
}

class _ClientMainPageState extends State<ClientMainPage> {
  List pages = [
    ClientHomePage(),
    ClientContractPage(),
    ClientVerificationPage(),
    MessageListPage(),
    ClientProfilePage(),
  ];

  int? currentIndex;
  void onTappedBar(int index) {
    Provider.of<ValueNotifier<int>>(context, listen: false).value = index;
    ClientHomePage.tabIndexNotifier.value = 0;
  }

  @override
  void initState() {
    SocketUtilsClient.instance.initSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    currentIndex = Provider.of<ValueNotifier<int>>(context).value;
    return Scaffold(
      body: pages[Provider.of<ValueNotifier<int>>(context).value],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0xff000000),
            blurRadius: Dimens.pixel_1,
            offset: Offset(Dimens.pixel_1, Dimens.pixel_1),
          )
        ]),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xffffffff),
          onTap: onTappedBar,
          currentIndex: Provider.of<ValueNotifier<int>>(context).value,
          selectedItemColor: AppColors.kDefaultPurpleColor,
          unselectedItemColor: Colors.black54,
          elevation: Dimens.pixel_0,
          iconSize: Dimens.pixel_28,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: Dimens.pixel_6),
                child: SvgPicture.asset(
                  Images.ic_home_big,
                  fit: BoxFit.scaleDown,
                  color: currentIndex == 0
                      ? AppColors.kDefaultPurpleColor
                      : AppColors.kdisabledColor,
                ),
              ),
              label: Strings.client_bottom_text_home,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: Dimens.pixel_6),
                child: SvgPicture.asset(
                  Images.ic_resume,
                  fit: BoxFit.scaleDown,
                  color: currentIndex == 1
                      ? AppColors.kDefaultPurpleColor
                      : AppColors.kdisabledColor,
                ),
              ),
              label: Strings.client_bottom_text_contracts,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: Dimens.pixel_6),
                child: SvgPicture.asset(
                  Images.ic_true,
                  height: Dimens.pixel_28,
                  color: currentIndex == 2
                      ? AppColors.kDefaultPurpleColor
                      : AppColors.kdisabledColor,
                ),
              ),
              label: Strings.client_bottom_text_verification,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(
                  bottom: Dimens.pixel_6,
                ),

                /// commented because don't have svg for message uncomment when available the svg
                // child: SvgPicture.asset(
                //   Images.ic_search,
                //   fit: BoxFit.scaleDown,
                //   color: currentIndex == 1
                //       ? AppColors.kDefaultPurpleColor
                //       : AppColors.kdisabledColor,
                // ),
                child: Icon(
                  Icons.message_outlined,
                  size: 25,
                  color: currentIndex == 3
                      ? AppColors.kDefaultPurpleColor
                      : AppColors.kdisabledColor,
                ),
              ),
              label: Strings.candidate_bottom_text_message,
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: Dimens.pixel_6),
                child: SvgPicture.asset(
                  Images.ic_personal_details,
                  fit: BoxFit.scaleDown,
                  color: currentIndex == 4
                      ? AppColors.kDefaultPurpleColor
                      : AppColors.kdisabledColor,
                ),
              ),
              label: Strings.client_bottom_text_profile,
            ),
          ],
        ),
      ),
    );
  }
}

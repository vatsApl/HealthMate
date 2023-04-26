import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/client_side/client_bottom_navigation/client_home_page.dart';
import 'package:clg_project/client_side/client_verification_pages/approvals.dart';
import 'package:clg_project/client_side/client_verification_pages/invoices.dart';
import 'package:clg_project/client_side/client_verification_pages/timesheets.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ClientVerificationPage extends BasePageScreen {
  @override
  State<ClientVerificationPage> createState() => _ClientVerificationPageState();
}

class _ClientVerificationPageState extends BasePageScreenState<ClientVerificationPage> with BaseScreen {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    isBackButton(false);
    currentIndex = ClientHomePage.tabIndexNotifier.value;
  }

  @override
  Widget body() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleText(title: Strings.text_title_verifications),
          const SizedBox(
            height: 48.0,
          ),
          Center(
            child: ToggleSwitch(
              initialLabelIndex: currentIndex,
              dividerColor: const Color(0xffE1E1E1),
              dividerMargin: 0.0,
              labels: const [
                Strings.text_approvals,
                Strings.text_timesheets,
                Strings.text_invoices,
              ],
              minWidth: 108.0,
              activeBgColor: const [
                kDefaultPurpleColor,
              ],
              inactiveBgColor: const Color(0xffFFFFFF),
              inactiveFgColor: klabelColor,
              cornerRadius: 6.0,
              borderColor: const [
                Color(0xffE1E1E1),
              ],
              borderWidth: 1.0,
              onToggle: (index) {
                setState(() {
                  currentIndex = index!;
                });
              },
            ),
          ),
          const SizedBox(
            height: 18.0,
          ),
          if (currentIndex == 0)
            Approvals()
          else if (currentIndex == 1)
            TimeSheets()
          else if (currentIndex == 2)
              Invoices(),
        ],
      ),
    );
  }
}
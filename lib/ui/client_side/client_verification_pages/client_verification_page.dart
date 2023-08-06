import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../MyFirebaseService.dart';
import '../../../resourse/app_colors.dart';
import '../../../resourse/dimens.dart';
import '../client_home_page/view/client_home_page.dart';
import 'job_approvals/view/approvals.dart';
import 'job_invoices/view/invoices.dart';
import 'job_timesheets/view/timesheets.dart';

class ClientVerificationPage extends BasePageScreen {
  @override
  State<ClientVerificationPage> createState() => _ClientVerificationPageState();
}

class _ClientVerificationPageState
    extends BasePageScreenState<ClientVerificationPage> with BaseScreen {
  int currentIndex = 0;

  getAnalytics() async {
    // google analytics
    await MyFirebaseService.logScreen('client verification screen');
  }

  @override
  void initState() {
    super.initState();
    isBackButton(false);
    currentIndex = ClientHomePage.tabIndexNotifier.value;
    getAnalytics();
  }

  @override
  Widget body() {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ValueNotifier<int>>(context, listen: false).value = 0;
        return false;
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.pixel_16,
              ),
              child: TitleText(title: Strings.text_title_verifications),
            ),
            const SizedBox(
              height: Dimens.pixel_48,
            ),
            Center(
              child: FittedBox(
                child: ToggleSwitch(
                  initialLabelIndex: currentIndex,
                  dividerColor: const Color(0xffE1E1E1),
                  dividerMargin: Dimens.pixel_0,
                  labels: const [
                    Strings.text_approvals,
                    Strings.text_timesheets,
                    Strings.text_invoices,
                  ],
                  // minWidth: 108.0, //previously added mannually width of toggle switch
                  minWidth: double.infinity,
                  activeBgColor: const [
                    AppColors.kDefaultPurpleColor,
                  ],
                  inactiveBgColor: const Color(0xffFFFFFF),
                  inactiveFgColor: AppColors.klabelColor,
                  cornerRadius: Dimens.pixel_6,
                  borderColor: const [
                    Color(0xffE1E1E1),
                  ],
                  borderWidth: Dimens.pixel_1,
                  onToggle: (index) {
                    setState(() {
                      currentIndex = index!;
                    });
                  },
                ),
              ),
            ),
            if (currentIndex == 0)
              Approvals()
            else if (currentIndex == 1)
              TimeSheets()
            else if (currentIndex == 2)
              Invoices(),
          ],
        ),
      ),
    );
  }
}

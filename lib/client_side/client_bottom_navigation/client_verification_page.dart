import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/client_side/client_bottom_navigation/client_home_page.dart';
import 'package:clg_project/client_side/client_verification_pages/approvals.dart';
import 'package:clg_project/client_side/client_verification_pages/invoices.dart';
import 'package:clg_project/client_side/client_verification_pages/timesheets.dart';
import 'package:clg_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ClientVerificationPage extends StatefulWidget {
  const ClientVerificationPage({Key? key}) : super(key: key);

  @override
  State<ClientVerificationPage> createState() => _ClientVerificationPageState();
}

class _ClientVerificationPageState extends State<ClientVerificationPage> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    currentIndex = ClientHomePage.tabIndexNotifier.value;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0.0,
      //   leading: InkWell(
      //     onTap: () {
      //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ClientMainPage(),),);
      //     },
      //     child: SvgPicture.asset(
      //       Images.ic_left_arrow,
      //       fit: BoxFit.scaleDown,
      //     ),
      //   ),
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 35.0, 16.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: 'Verifications'),
              const SizedBox(
                height: 48.0,
              ),
              Center(
                child: ToggleSwitch(
                  initialLabelIndex: currentIndex,
                  dividerColor: const Color(0xffE1E1E1),
                  dividerMargin: 0.0,
                  labels: const [
                    'Approvals',
                    'Timesheets',
                    'Invoices',
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
                const Approvals()
              else if (currentIndex == 1)
                const TimeSheets()
              else if (currentIndex == 2)
                const Invoices(),
            ],
          ),
        ),
      ),
    );
  }
}

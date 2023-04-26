import 'package:clg_project/UI/widgets/signup_candidate.dart';
import 'package:clg_project/UI/widgets/signup_client.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../resourse/strings.dart';

class SignUpPage extends BasePageScreen {

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends BasePageScreenState<SignUpPage> with TickerProviderStateMixin, BaseScreen {
  int currentIndex = 0;

  // previously tried but not done, used instead of toggle switch library:
  // static const List<Tab> _tabs = [
  //   const Tab(child: Text('Candidate')),
  //   const Tab(text: 'Client'),
  // ];

  // static const List<Widget> _views = [
  //   const Center(child: const Text('Content of Tab One')),
  //   const Center(child: const Text('Content of Tab Two')),
  // ];

  // TabController? _tabController;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _tabController = TabController(length: _tabs.length, vsync: this);
  // }

  @override
  Widget body() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 23.0,
            ),
            TitleText(title: Strings.sign_up_text_title),
            const SizedBox(
              height: 55.0,
            ),
            // previously tried but not done, used instead of toggle switch library:
            /* TabBar(
                  controller: _tabController,
                  tabs: _tabs,
                  labelColor: Color(0xffffffff),
                  unselectedLabelColor: klabelColor,
                  indicator: BoxDecoration(
                    color: kDefaultPurpleColor,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.fromBorderSide(BorderSide(width: 1.0, color: klabelColor,),),
                  ),
                ),
              SizedBox(
                height: 30.0,
              ),

              TabBarView(children: _views, controller: _tabController,),
*/

            // previous perfact toggle switch:
            Center(
              child: ToggleSwitch(
                initialLabelIndex: currentIndex,
                labels: const [
                  Strings.sign_up_text_candidate,
                  Strings.sign_up_text_client,
                ],
                minWidth: 162.0,
                activeBgColor: const [
                  kDefaultPurpleColor,
                ],
                inactiveBgColor: const Color(0xffFFFFFF),
                inactiveFgColor: klabelColor,
                activeFgColor: const Color(0xffFFFFFF),
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
              height: 30.0,
            ),
            currentIndex == 0 ? SignUpCandidate() : SignUpClient(),
          ],
        ),
      ),
    );
  }
}

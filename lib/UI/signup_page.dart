import 'package:clg_project/UI/widgets/signup_candidate.dart';
import 'package:clg_project/UI/widgets/signup_client.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with TickerProviderStateMixin {
  int currentIndex = 0;

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 63.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(Images.ic_left_arrow,
                    fit: BoxFit.scaleDown),
              ),
              const SizedBox(
                height: 23.0,
              ),
              TitleText(title: 'Sign Up!'),
              const SizedBox(
                height: 55.0,
              ),
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
                    'Candidate',
                    'Client',
                  ],
                  // customTextStyles: [
                  //   TextStyle(
                  //     fontSize: 16.0,
                  //     // fontWeight: FontWeight.w500,
                  //     // color: ,
                  //   )
                  // ],
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
              currentIndex == 0
                  ? const SignUpCandidate()
                  : const SignUpClient(),
            ],
          ),
        ),
      ),
    );
  }
}

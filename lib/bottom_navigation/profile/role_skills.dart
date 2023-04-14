import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../allAPIs/allAPIs.dart';
import '../../custom_widgets/custom_widget_helper.dart';
import '../../models/candidate_models/find_job_response.dart';
import '../../models/onchange_skills_res.dart';
import '../../models/roles_skills_res.dart';
import '../../resourse/shared_prefs.dart';
import 'package:http/http.dart' as http;

class RoleSkills extends StatefulWidget {
  const RoleSkills({Key? key}) : super(key: key);
  @override
  State<RoleSkills> createState() => _RoleSkillsState();
}

class _RoleSkillsState extends State<RoleSkills> {
  String dropdownValue = 'Dentist';
  bool isVisible = false;
  String? selectedRoleItem = 'Select Role';
  int selectedRoleIndex = 0;
  int? selectedRoleIndexOnchangeSkills;
  int selectedIndex = 0;
  int? _selectedValue;

  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  List<String> allRole = [];
  List<String> skill = [];

  var roleAndSkillsResponse;

  //role & skills api:
  Future<void> roleAndSkillsApi() async {
    final url = Uri.parse('${DataURL.baseUrl}/api/edit/candidate/$uId/role');
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.get(url);
      log('role & skills:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        roleAndSkillsResponse = RoleAndSkillsResponse.fromJson(json);
        // print('this:${roleAndSkillsResponse.allRole}');
        setState(() {
          allRole = roleAndSkillsResponse.allRole;
          skill = roleAndSkillsResponse.data;
          selectedRoleItem = roleAndSkillsResponse.role;
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        isVisible = false;
      });
    }
    setState(() {
      isVisible = false;
    });
  }

  // onchange skills api:
  Future<void> onchangeSkillsApi() async {
    final url = Uri.parse(
        '${DataURL.baseUrl}/api/onchange/get/skills/$selectedRoleIndexOnchangeSkills');
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.get(url);
      log('ONCHANGE skills:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var onchangeSkillsResponse = OnchangeSkillResponse.fromJson(json);
        print('onchange Skills:${onchangeSkillsResponse.data}');
        setState(() {
          skill = onchangeSkillsResponse.data ?? [];
          // selectedRoleItem = roleAndSkillsResponse.role;
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        isVisible = false;
      });
    }
    setState(() {
      isVisible = false;
    });
  }

  // select role dropdown:
  Future<void> dropdownDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
          child: SizedBox(
            height: 469.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 34.0,
                    left: 26.0,
                  ),
                  child: Text(
                    'Select Role',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: kDefaultBlackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 48.5),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: allRole.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: double.infinity,
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 26.0,
                            ),
                            child: Column(
                              children: [
                                RadioListTile(
                                  contentPadding: EdgeInsets.zero,
                                  toggleable: true,
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  title: Text(
                                    allRole[index].toString(),
                                    style: TextStyle(
                                      color: selectedRoleIndex == index ? kDefaultBlackColor : klabelColor,
                                      fontWeight: selectedRoleIndex == index ? FontWeight.w500 : FontWeight.w400,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  value: allRole[index],
                                  groupValue: selectedRoleItem,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedRoleItem = value.toString();
                                      selectedRoleIndex =
                                          allRole.indexOf('$selectedRoleItem');
                                      selectedRoleIndexOnchangeSkills =
                                          selectedRoleIndex + 1;
                                      print(selectedRoleIndexOnchangeSkills);
                                      // onchange skill api call:
                                      onchangeSkillsApi();
                                      // print(allRoles.indexOf(selectedRoleItem!));
                                      // selectedRoleIndex =
                                      //     allRole.indexOf(selectedRoleItem!);
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                const Divider(
                                  color: Color(0xffF4F2F2),
                                  height: 1.0,
                                  thickness: 1.0,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //update role api:
  Future<void> updateRoleApi() async {
    final url = Uri.parse('${DataURL.baseUrl}/api/update/candidate/$uId/role');
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.post(url, body: {
        'role': selectedRoleIndexOnchangeSkills.toString(),
      });
      log('update Role:${response.body}');
      if (response.statusCode == 200) {
        setState(() {
          PreferencesHelper.setString(
              PreferencesHelper.KEY_ROLE_NAME, selectedRoleItem.toString());
        });
        var json = jsonDecode(response.body);
        Fluttertoast.showToast(
          msg: "${json['message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: json['code'] == 200 ? Colors.green : Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        isVisible = false;
      });
    }
    setState(() {
      isVisible = false;
    });
  }

  @override
  void initState() {
    super.initState();
    roleAndSkillsApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomWidgetHelper.appBar(
        context: context,
        onActionTap: () {
          //updateRole api:
          updateRoleApi();
        },
        action: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SvgPicture.asset(
            Images.ic_true,
            height: 28.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     InkWell(
            //       onTap: () {
            //         Navigator.pop(context);
            //       },
            //       child: SvgPicture.asset(Images.ic_left_arrow),
            //     ),
            //     GestureDetector(
            //       onTap: () {},
            //       child: SvgPicture.asset(
            //         Images.ic_true,
            //         height: 28.0,
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 23.0,
            ),
            TitleText(title: 'Role & Skills'),
            const SizedBox(
              height: 48.0,
            ),
            const Text(
              'Role',
              style: TextStyle(
                  color: kDefaultBlackColor, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 15.5,
            ),
            GestureDetector(
              onTap: () {
                dropdownDialog();
              },
              child: TextFormField(
                textAlignVertical: TextAlignVertical.bottom,
                enabled: false,
                decoration: InputDecoration(
                  hintText: selectedRoleItem == 'null'
                      ? 'Select Role'
                      : selectedRoleItem,
                  hintStyle: const TextStyle(
                    color: klabelColor,
                  ),
                  labelStyle: const TextStyle(
                    color: klabelColor,
                  ),
                  suffixIcon: const Padding(
                    padding: kSuffixIconPadding,
                    child: Icon(Icons.keyboard_arrow_down_outlined),
                  ),
                  disabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            const Text(
              'Skills',
              style: TextStyle(
                color: kDefaultBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 24.0,
            ),
            SingleChildScrollView(
              child: Wrap(
                alignment: WrapAlignment.start,
                direction: Axis.horizontal,
                children: returnList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  returnList() {
    List<Widget> tag = [];
    for (int i = 0; i < skill.length; i++) {
      tag.add(
        Padding(
          padding: const EdgeInsets.only(right: 11.0),
          child: Chip(
            backgroundColor: const Color(0xffbacF4F2F2),
            label: Text(
              skill[i],
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: klabelColor,
              ),
            ),
          ),
        ),
      );
    }
    return tag;
  }
}

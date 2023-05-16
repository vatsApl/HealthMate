import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../models/onchange_skills_res.dart';
import '../../models/roles_skills_res.dart';
import '../../resourse/app_colors.dart';
import '../../resourse/dimens.dart';
import '../../resourse/shared_prefs.dart';
import 'package:http/http.dart' as http;
import '../../resourse/strings.dart';

class RoleSkills extends BasePageScreen {
  @override
  State<RoleSkills> createState() => _RoleSkillsState();
}

class _RoleSkillsState extends BasePageScreenState<RoleSkills> with BaseScreen {
  bool isVisible = false;
  String? selectedRoleItem = Strings.default_selected_role_item;
  int selectedRoleIndex = 0;
  int? selectedRoleIndexOnchangeSkills;
  int selectedIndex = 0;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  List<String> allRole = [];
  List<String> skill = [];
  var roleAndSkillsResponse;

  // candidate role & skills api:
  Future<void> roleAndSkillsApi() async {
    try {
      setState(() {
        isVisible = true;
      });
      String url = ApiUrl.roleAndSkillsApi(uId);
      var response = await http.get(Uri.parse(url));
      // log('role & skills:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        roleAndSkillsResponse = RoleAndSkillsResponse.fromJson(json);
        print('this:${roleAndSkillsResponse.allRole}');
        setState(() {
          allRole = roleAndSkillsResponse.allRole;
          skill = roleAndSkillsResponse.data;
          selectedRoleItem = roleAndSkillsResponse.role;
          selectedRoleIndex = allRole.indexOf(selectedRoleItem ?? '');
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
    final url = ApiUrl.onchangeSkillsApi(selectedRoleIndexOnchangeSkills);
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.get(Uri.parse(url));
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
          insetPadding: const EdgeInsets.symmetric(
            horizontal: Dimens.pixel_16,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
          child: SizedBox(
            height: Dimens.pixel_469,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: Dimens.pixel_34,
                    left: Dimens.pixel_26,
                  ),
                  child: Text(
                    Strings.text_select_role,
                    style: TextStyle(
                      fontSize: Dimens.pixel_20,
                      color: AppColors.kDefaultBlackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: Dimens.pixel_48_and_half,
                    ),
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
                              horizontal: Dimens.pixel_26,
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
                                      color: selectedRoleIndex == index
                                          ? AppColors.kDefaultBlackColor
                                          : AppColors.klabelColor,
                                      fontWeight: selectedRoleIndex == index
                                          ? FontWeight.w500
                                          : FontWeight.w400,
                                      fontSize: Dimens.pixel_16,
                                    ),
                                  ),
                                  activeColor: AppColors.kDefaultPurpleColor,
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
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                const Divider(
                                  color: Color(0xffF4F2F2),
                                  height: Dimens.pixel_1,
                                  thickness: Dimens.pixel_1,
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
    final url = ApiUrl.updateRoleApi(uId);
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.post(Uri.parse(url), body: {
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
    isSaveButton(true);
    roleAndSkillsApi();
  }

  returnListOfSkills() {
    List<Widget> tag = [];
    for (int i = 0; i < skill.length; i++) {
      tag.add(
        Padding(
          padding: const EdgeInsets.only(
            right: Dimens.pixel_11,
          ),
          child: Chip(
            backgroundColor: const Color(0xffbacF4F2F2),
            label: Text(
              skill[i],
              style: const TextStyle(
                fontSize: Dimens.pixel_12,
                fontWeight: FontWeight.w400,
                color: AppColors.klabelColor,
              ),
            ),
          ),
        ),
      );
    }
    return tag;
  }

  @override
  void onClickSaveButton() {
    // updateRole api call:
    updateRoleApi();
  }

  @override
  Widget body() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimens.pixel_16,
        Dimens.pixel_0,
        Dimens.pixel_16,
        Dimens.pixel_16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: Dimens.pixel_23,
          ),
          TitleText(
            title: Strings.text_role_and_skills,
          ),
          const SizedBox(
            height: Dimens.pixel_48,
          ),
          const Text(
            Strings.text_role,
            style: TextStyle(
              color: AppColors.kDefaultBlackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: Dimens.pixel_15_and_half,
          ),
          GestureDetector(
            onTap: () {
              dropdownDialog();
            },
            child: TextFormField(
              textAlignVertical: TextAlignVertical.bottom,
              enabled: false,
              decoration: InputDecoration(
                hintText: selectedRoleItem == Strings.text_null
                    ? Strings.text_select_role
                    : selectedRoleItem,
                hintStyle: const TextStyle(
                  color: AppColors.klabelColor,
                ),
                labelStyle: const TextStyle(
                  color: AppColors.klabelColor,
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
            height: Dimens.pixel_50,
          ),
          const Text(
            Strings.text_skills,
            style: TextStyle(
              color: AppColors.kDefaultBlackColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(
            height: Dimens.pixel_24,
          ),
          SingleChildScrollView(
            child: Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.horizontal,
              children: returnListOfSkills(),
            ),
          ),
        ],
      ),
    );
  }
}

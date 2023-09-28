import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/custom_widgets/custom_widget_helper.dart';
import 'package:clg_project/ui/candidate_side/candidate_profile_page/role_and_skills/bloc/role_skills_state.dart';
import 'package:clg_project/ui/candidate_side/candidate_profile_page/role_and_skills/repo/role_skills_repository.dart';
import 'package:clg_project/ui/client_side/client_home_page/client_job_description/model/basic_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../MyFirebaseService.dart';
import '../../../../../resourse/app_colors.dart';
import '../../../../../resourse/dimens.dart';
import '../../../../../resourse/shared_prefs.dart';
import '../../../../../resourse/strings.dart';
import '../bloc/role_skills_bloc.dart';
import '../bloc/role_skills_event.dart';
import '../model/onchange_skills_res.dart';
import '../model/roles_skills_res.dart';

class RoleAndSkills extends BasePageScreen {
  @override
  State<RoleAndSkills> createState() => _RoleSkillsState();
}

class _RoleSkillsState extends BasePageScreenState<RoleAndSkills>
    with BaseScreen {
  bool isVisible = false;
  bool isUpdateLoading = false;
  String? selectedRoleItem = Strings.default_selected_role_item;
  int selectedRoleIndex = 0;
  int? selectedRoleIndexOnchangeSkills;
  int selectedIndex = 0;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  List<String> allRole = [];
  List<String> skill = [];
  var roleAndSkillsResponse;

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
                                      // onchangeSkillsApi(); // onchange skill api call
                                      /// event of onchange skill
                                      _roleAndSkillsBloc
                                          .add(OnChangeSkillsEvent(
                                        selectedRoleIndexOnchangeSkills:
                                            selectedRoleIndexOnchangeSkills,
                                      ));
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

  getAnalytics() async {
    // google analytics
    await MyFirebaseService.logScreen('candidate role & skills screen');
  }

  @override
  void initState() {
    super.initState();
    isSaveButton(true);

    /// event of show role and skill
    _roleAndSkillsBloc.add(ShowRoleAndSkillsEvent());
    getAnalytics();
  }

  final _roleAndSkillsBloc = RoleAndSkillsBloc(RoleAndSkillsRepository());

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
    /// event of update role
    var params = {
      'role': selectedRoleIndexOnchangeSkills.toString(),
    };
    _roleAndSkillsBloc.add(UpdateRoleEvent(params: params));
  }

  @override
  void dispose() {
    _roleAndSkillsBloc.close();
    super.dispose();
  }

  @override
  Widget body() {
    return BlocProvider<RoleAndSkillsBloc>(
      create: (BuildContext context) => _roleAndSkillsBloc,
      child: BlocListener<RoleAndSkillsBloc, RoleAndSkillsState>(
        listener: (BuildContext context, state) {
          if (state is ShowRoleAndSkillsLoadingState) {
            isVisible = true;
          }
          if (state is ShowRoleAndSkillsLoadedState) {
            isVisible = false;
            var responseBody = state.response;
            roleAndSkillsResponse =
                RoleAndSkillsResponse.fromJson(responseBody);
            if (roleAndSkillsResponse.code == 200) {
              setState(() {
                allRole = roleAndSkillsResponse.allRole;
                skill = roleAndSkillsResponse.data;
                selectedRoleItem = roleAndSkillsResponse.role;
                selectedRoleIndex = allRole.indexOf(selectedRoleItem ?? '');
              });
            }
          }
          if (state is ShowRoleAndSkillsErrorState) {
            debugPrint(state.error);
          }
          if (state is UpdateRoleLoadingState) {
            isUpdateLoading = true;
          }
          if (state is UpdateRoleLoadedState) {
            isUpdateLoading = false;
            var responseBody = state.response;
            var basicModel = BasicModel.fromJson(responseBody);
            if (basicModel.code == 200) {
              // setState(() {
              PreferencesHelper.setString(
                  PreferencesHelper.KEY_ROLE_NAME, selectedRoleItem.toString());
              // });
              Fluttertoast.showToast(
                msg: "${basicModel.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Navigator.pop(context);
            }
          }
          if (state is UpdateRoleErrorState) {
            debugPrint(state.error);
          }
          if (state is OnChangeSkillsLoadingState) {
            isUpdateLoading = true;
          }
          if (state is OnChangeSkillsLoadedState) {
            isUpdateLoading = false;
            var responseBody = state.response;
            var onchangeSkillsResponse =
                OnchangeSkillResponse.fromJson(responseBody);
            if (onchangeSkillsResponse.code == 200) {
              print('onchange Skills:${onchangeSkillsResponse.data}');
              setState(() {
                skill = onchangeSkillsResponse.data ?? [];
                // selectedRoleItem = roleAndSkillsResponse.role;
              });
            }
          }
          if (state is OnChangeSkillsErrorState) {
            debugPrint(state.error);
          }
        },
        child: Stack(
          children: [
            isVisible
                ? CustomWidgetHelper.Loader(context: context)
                : Padding(
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
                  ),
            Visibility(
              visible: isUpdateLoading,
              child: CustomWidgetHelper.Loader(context: context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    // TODO: implement update
    throw UnimplementedError();
  }
}

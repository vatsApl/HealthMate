import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/candidate_models/job_description_res.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/client_side/client_home_page/client_job_description/bloc/client_job_desc_bloc.dart';
import 'package:clg_project/ui/client_side/client_home_page/client_job_description/bloc/client_job_desc_event.dart';
import 'package:clg_project/ui/client_side/client_home_page/client_job_description/bloc/client_job_desc_state.dart';
import 'package:clg_project/ui/client_side/client_home_page/client_job_description/model/basic_model.dart';
import 'package:clg_project/ui/client_side/client_home_page/client_job_description/repo/client_job_desc_repository.dart';
import 'package:clg_project/widgets/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../../../custom_widgets/custom_widget_helper.dart';
import '../../../../../models/candidate_models/find_job_response.dart';
import '../../../../../resourse/app_colors.dart';
import '../../../../../resourse/dimens.dart';
import '../../../client_main_page.dart';

class ClientJobDescription extends BasePageScreen {
  int? jobId;
  ClientJobDescription({this.jobId});
  @override
  State<ClientJobDescription> createState() => _ClientJobDescriptionState();
}

class _ClientJobDescriptionState
    extends BasePageScreenState<ClientJobDescription> with BaseScreen {
  JobModel? jobDesc;
  bool isVisible = false;
  bool isRemoveContractLoading = false;

  @override
  void initState() {
    super.initState();
    // event of show job desc
    _clientJobDescBloc.add(ShowJobDescEvent(jobId: widget.jobId));
  }

  final _clientJobDescBloc = ClientJobDescBloc(ClientJobDescRepository());

  @override
  Widget body() {
    return BlocProvider<ClientJobDescBloc>(
      create: (BuildContext context) => _clientJobDescBloc,
      child: BlocConsumer<ClientJobDescBloc, ClientJobDescState>(
        listener: (BuildContext context, state) {
          if (state is ShowJobDescLoadingState) {
            isVisible = true;
          }
          if (state is ShowJobDescLoadedState) {
            var responseBody = state.response;
            var joDetailResponse =
                JobDescriptionResponse.fromJson(responseBody);
            jobDesc = joDetailResponse.data;
            isVisible = false;
          }
          if (state is ShowJobDescErrorState) {
            debugPrint(state.error);
          }
          if (state is RemoveContractLoadingState) {
            isRemoveContractLoading = true;
          }
          if (state is RemoveContractLoadedState) {
            isRemoveContractLoading = false;
            var responseBody = state.response;
            var basicModel = BasicModel.fromJson(responseBody);
            if (basicModel.code == 200) {
              Fluttertoast.showToast(
                msg: "${basicModel.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) =>
                        ChangeNotifierProvider<ValueNotifier<int>>.value(
                      value: ValueNotifier<int>(0),
                      child: ClientMainPage(),
                    ),
                  ),
                  (route) => false);
            } else {
              Fluttertoast.showToast(
                msg: "${basicModel.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }
          }
          if (state is RemoveContractErrorState) {
            debugPrint(state.error);
          }
        },
        builder: (BuildContext context, Object? state) {
          return isVisible
              ? CustomWidgetHelper.Loader(context: context)
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Dimens.pixel_16,
                      Dimens.pixel_27,
                      Dimens.pixel_16,
                      Dimens.pixel_0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleText(title: '${jobDesc?.jobTitle.toString()}'),
                        const SizedBox(
                          height: Dimens.pixel_38,
                        ),
                        const Text(
                          Strings.text_job_description,
                          style: TextStyle(
                            color: AppColors.kDefaultBlackColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: Dimens.pixel_10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: Dimens.pixel_24,
                          ),
                          child: Text(
                            '${jobDesc?.jobDescription.toString()}',
                            style: const TextStyle(
                              color: AppColors.klabelColor,
                              fontWeight: FontWeight.w400,
                              height: Dimens.pixel_1_point_2,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: Dimens.pixel_33,
                              ),
                              child: SvgPicture.asset(
                                Images.ic_location_circle,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: Dimens.pixel_30,
                                  left: Dimens.pixel_20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      Strings.text_location,
                                      style: kDescText1,
                                    ),
                                    const SizedBox(height: Dimens.pixel_10),
                                    Text(
                                      '${jobDesc?.jobLocation.toString()}',
                                      style: kDescText2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: Dimens.pixel_26),
                              child: SvgPicture.asset(
                                Images.ic_calander_rounded,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: Dimens.pixel_13,
                                left: Dimens.pixel_20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    Strings.text_date,
                                    style: kDescText1,
                                  ),
                                  const SizedBox(
                                    height: Dimens.pixel_10,
                                  ),
                                  Text(
                                    '${jobDesc?.jobDate}',
                                    style: kDescText2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: Dimens.pixel_19,
                              ),
                              child: SvgPicture.asset(
                                Images.ic_time,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: Dimens.pixel_13, left: Dimens.pixel_20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    Strings.text_time,
                                    style: kDescText1,
                                  ),
                                  const SizedBox(
                                    height: Dimens.pixel_10,
                                  ),
                                  Text(
                                    '${jobDesc?.jobStartTime.toString()} - ${jobDesc?.jobEndTime.toString()}',
                                    style: kDescText2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: Dimens.pixel_20,
                              ),
                              child: SvgPicture.asset(
                                Images.ic_income,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: Dimens.pixel_13,
                                left: Dimens.pixel_20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    Strings.text_pay,
                                    style: kDescText1,
                                  ),
                                  const SizedBox(
                                    height: Dimens.pixel_10,
                                  ),
                                  Text(
                                    '${jobDesc?.jobSalary.toString()} ${Strings.text_per_day}',
                                    style: kDescText2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: Dimens.pixel_26,
                              ),
                              child: SvgPicture.asset(
                                Images.ic_job_rounded,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: Dimens.pixel_13,
                                left: Dimens.pixel_20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    Strings.text_units,
                                    style: kDescText1,
                                  ),
                                  const SizedBox(
                                    height: Dimens.pixel_10,
                                  ),
                                  Text(
                                    jobDesc?.jobUnit == null
                                        ? Strings.default_job_unit
                                        : '${jobDesc?.jobUnit?.toStringAsFixed(2)}',
                                    style: kDescText2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: Dimens.pixel_33,
                        ),
                        kDivider,
                        const SizedBox(
                          height: Dimens.pixel_20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      Images.ic_parking,
                                      fit: BoxFit.scaleDown,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: Dimens.pixel_6,
                                      ),
                                      child: Text(
                                        '${jobDesc?.jobParking.toString()}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: Dimens.pixel_12,
                                          color: AppColors.klabelColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Dimens.pixel_15,
                                  ),
                                  child: Text(
                                    '.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      Images.ic_break,
                                      fit: BoxFit.scaleDown,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: Dimens.pixel_6,
                                      ),
                                      child: Text(
                                        '${jobDesc?.breakTime} ${Strings.text_minutes}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: Dimens.pixel_12,
                                          color: AppColors.klabelColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Dimens.pixel_50,
                          ),
                          child: ElevatedBtn(
                            btnTitle: Strings.text_remove_contract,
                            bgColor: AppColors.kDefaultPurpleColor,
                            isLoading: isVisible,
                            onPressed: () {
                              // event of remove contract
                              _clientJobDescBloc.add(
                                  RemoveContractEvent(jobId: widget.jobId));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }
}

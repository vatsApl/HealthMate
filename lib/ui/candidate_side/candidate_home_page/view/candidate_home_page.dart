import 'package:clg_project/UI/widgets/candidate_card_top.dart';
import 'package:clg_project/UI/widgets/custom_appbar.dart';
import 'package:clg_project/UI/widgets/job_card_home_page.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/helper/socket_io_client.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:clg_project/ui/candidate_side/candidate_home_page/bloc/candidate_home_page_state.dart';
import 'package:clg_project/ui/candidate_side/candidate_home_page/candidate_job_description/view/job_description.dart';
import 'package:clg_project/ui/candidate_side/candidate_home_page/repo/candidate_home_page_repo.dart';
import 'package:clg_project/ui/candidate_side/find_job/model/find_job_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../MyFirebaseService.dart';
import '../../../../custom_widgets/custom_widget_helper.dart';
import '../../../../custom_widgets/index_notifier.dart';
import '../../../../resourse/dimens.dart';
import '../../../../resourse/strings.dart';
import '../bloc/candidate_home_page_bloc.dart';
import '../bloc/candidate_home_page_event.dart';

class CandidateHomePage extends StatefulWidget {
  static ValueNotifier tabIndexNotifier = TabIndexNotifier();

  @override
  State<CandidateHomePage> createState() => _CandidateHomePageState();
}

class _CandidateHomePageState extends State<CandidateHomePage> {
  bool isVisible = false;
  bool? isLastPage;
  List<JobModel?> jobsHome = [];
  var homePageResponse2;
  var homePageResponse3;
  int page = 1;
  bool isLoadingMore = false;
  final scrollController = ScrollController();
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  var uIdInt = PreferencesHelper.getInt(PreferencesHelper.KEY_USER_ID_INT);
  var uFirstName =
      PreferencesHelper.getString(PreferencesHelper.KEY_FIRST_NAME);
  var uRoleName = PreferencesHelper.getString(PreferencesHelper.KEY_ROLE_NAME);
  String? netImg = PreferencesHelper.getString(PreferencesHelper.KEY_AVATAR);

  getAnalytics() async {
    // google analytics
    await MyFirebaseService.logScreen('candidate home screen');
  }

  int? userType = PreferencesHelper.getInt(PreferencesHelper.KEY_USER_TYPE);

  @override
  void initState() {
    // if (SocketUtilsClient.instance?.socket == null) {
    //   SocketUtilsClient.instance.initSocket();
    // }
    super.initState();
    // event of show home page data
    _candidateHomePageBloc.add(ShowCandidateHomePageData());
    print('current:$uId');
    debugPrint('This is the user type: $userType');
    getAnalytics();
  }

  final _candidateHomePageBloc = CandidateHomePageBloc(CandidateHomePageRepo());

  @override
  void dispose() {
    _candidateHomePageBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(Strings.text_confirm_exit),
                content: Text(
                  Strings.text_confirm_exit_msg,
                  style: TextStyle(
                    height: Dimens.pixel_1_point_2,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(Strings.capital_text_yes),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                  TextButton(
                    child: Text(Strings.capital_text_no),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          name: uFirstName,
          role: uRoleName,
          svgPictureTrailing: Images.ic_notification,
          netImg: netImg,
        ),
        body: BlocProvider<CandidateHomePageBloc>(
          create: (BuildContext context) => _candidateHomePageBloc,
          child: BlocConsumer<CandidateHomePageBloc, CandidateHomePageState>(
            listener: (BuildContext context, state) {
              if (state is CandidateHomePageLoadingState) {
                isVisible = true;
              }
              if (state is CandidateHomePageLoadedState) {
                var responseBody = state.response;
                var homePageResponse = FindJobResponse.fromJson(responseBody);
                homePageResponse2 = FindJobResponse.fromJson(responseBody);
                isVisible = false;
                if (homePageResponse.code == 200) {
                  isLastPage = homePageResponse.isLastPage;
                  jobsHome.addAll(homePageResponse.data ?? []);
                  isLoadingMore = false;
                } else {
                  homePageResponse3 = FindJobResponse.fromJson(responseBody);
                }
              }
              if (state is CandidateHomePageErrorState) {
                debugPrint(state.error);
              }
            },
            builder: (BuildContext context, Object? state) {
              return Container(
                padding: const EdgeInsets.fromLTRB(
                  Dimens.pixel_16,
                  Dimens.pixel_19,
                  Dimens.pixel_16,
                  Dimens.pixel_0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // previously used instead of appbar
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     SizedBox(
                    //       width: Dimens.pixel_55,
                    //       height: Dimens.pixel_55,
                    //       child: Container(
                    //         decoration: const BoxDecoration(
                    //           shape: BoxShape.circle,
                    //           color: AppColors.kDefaultPurpleColor,
                    //         ),
                    //         child: CachedNetworkImage(
                    //           imageUrl: '${DataURL.baseUrl}/$netImg',
                    //           imageBuilder: (context, imageProvider) => Container(
                    //             decoration: BoxDecoration(
                    //               shape: BoxShape.circle,
                    //               image: DecorationImage(
                    //                 image: imageProvider,
                    //                 fit: BoxFit.cover,
                    //               ),
                    //             ),
                    //           ),
                    //           placeholder: (context, url) => CircleAvatar(
                    //             child: SvgPicture.asset(
                    //               Images.ic_person,
                    //               color: Colors.white,
                    //               height: Dimens.pixel_35,
                    //             ),
                    //           ),
                    //           errorWidget: (context, url, error) => CircleAvatar(
                    //             child: SvgPicture.asset(
                    //               Images.ic_person,
                    //               color: Colors.white,
                    //               height: Dimens.pixel_35,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(
                    //       width: Dimens.pixel_14,
                    //     ),
                    //     Flexible(
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Text(
                    //                 uFirstName ?? '',
                    //                 style: const TextStyle(
                    //                   color: AppColors.kDefaultPurpleColor,
                    //                   fontSize: Dimens.pixel_18,
                    //                   fontWeight: FontWeight.w700,
                    //                 ),
                    //               ),
                    //               Text(
                    //                 uRoleName,
                    //                 style: const TextStyle(
                    //                   color: AppColors.kDefaultBlackColor,
                    //                   height: Dimens.pixel_1_point_2,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           SvgPicture.asset(
                    //             Images.ic_notification,
                    //             fit: BoxFit.scaleDown,
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    Expanded(
                      child: SingleChildScrollView(
                        clipBehavior: Clip.none,
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: Dimens.pixel_48,
                          ),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: CardTopCandidate(
                                      onTap: () {
                                        Provider.of<ValueNotifier<int>>(context,
                                                listen: false)
                                            .value = 2;
                                        CandidateHomePage
                                            .tabIndexNotifier.value = 0;
                                      },
                                      icon: Images.ic_applied,
                                      number: homePageResponse2?.appliedCount ??
                                          homePageResponse3?.appliedCount ??
                                          0,
                                      label: Strings.candidate_text_applied,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: Dimens.pixel_22,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: CardTopCandidate(
                                      onTap: () {
                                        //Navigate to worked page.
                                        Provider.of<ValueNotifier<int>>(context,
                                                listen: false)
                                            .value = 2;
                                        CandidateHomePage
                                            .tabIndexNotifier.value = 2;
                                      },
                                      icon: Images.ic_worked,
                                      number: homePageResponse2?.workedCount ??
                                          homePageResponse3?.workedCount ??
                                          0,
                                      label: Strings.candidate_text_worked,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: Dimens.pixel_14,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    child: CardTopCandidate(
                                      onTap: () {
                                        // Navigate to Booked page.
                                        Provider.of<ValueNotifier<int>>(context,
                                                listen: false)
                                            .value = 2;
                                        CandidateHomePage
                                            .tabIndexNotifier.value = 1;
                                      },
                                      icon: Images.ic_booked,
                                      number: homePageResponse2?.bookedCount ??
                                          homePageResponse3?.bookedCount ??
                                          0,
                                      label: Strings.candidate_text_booked,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: Dimens.pixel_22,
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: CardTopCandidate(
                                      icon: Images.ic_payment,
                                      amountSymbol: Strings.amount_symbol_rupee,
                                      number: homePageResponse2?.totalPayment ??
                                          homePageResponse3?.totalPayment ??
                                          0,
                                      isPrice: true,
                                      label:
                                          Strings.candidate_home_text_payment,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: Dimens.pixel_19,
                              ),
                              kDivider, //default divider
                              jobList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (isVisible)
                      Expanded(
                        child: CustomWidgetHelper.Loader(context: context),
                      ),
                    if (jobsHome.isEmpty && !isVisible)
                      Expanded(
                        child: Container(
                          child: Center(
                            child: Text(
                              Strings.candidate_text_no_jobs_found,
                              style: kDefaultEmptyFieldTextStyle,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  jobList() {
    return jobsHome.isEmpty && !isVisible
        ? Container()
        : ListView.separated(
            // controller: scrollController, //will not work because of physics!
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              vertical: Dimens.pixel_15,
            ),
            shrinkWrap: true,
            primary: false,
            itemCount: jobsHome.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  int? jobId = jobsHome[index]?.id;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDescription(
                        jobId: jobId,
                      ),
                    ),
                  );
                },
                child: JobCardCandidate(
                  homePageModel: jobsHome[index],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: Dimens.pixel_20,
              );
            },
          );
  }
}

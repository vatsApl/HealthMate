import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clg_project/UI/job_description.dart';
import 'package:clg_project/UI/widgets/candidate_card_top.dart';
import 'package:clg_project/UI/widgets/job_card_home_page.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/candidate_models/find_job_response.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../custom_widgets/index_notifier.dart';
import '../resourse/api_urls.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static ValueNotifier tabIndexNotifier = TabIndexNotifier();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  Future<void> homePageCandidateApi() async {
    String url = ApiUrl.homePageCandidateApi(uId);
    final urlParsed = Uri.parse(url);
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.get(urlParsed);
      log('home res:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var homePageResponse = FindJobResponse.fromJson(json);
        homePageResponse2 = FindJobResponse.fromJson(json);
        isLastPage = homePageResponse.isLastPage;
        setState(() {
          isVisible = false;
          isLoadingMore = false;
          jobsHome.addAll(homePageResponse.data ?? []);
        });
      } else if (response.statusCode == 400) {
        var json = jsonDecode(response.body);
        var homePageResponse = FindJobResponse.fromJson(json);
        homePageResponse3 = FindJobResponse.fromJson(json);
        print(homePageResponse3.appliedCount);
      }
    } catch (e) {
      print(e);
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
    homePageCandidateApi();
    print('current:$uId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      // appBar: CustomAppBar(name: uFirstName, role: uRoleName, svgPictureTrailing: Images.ic_notification, netImg: netImg,),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 63.0, 16.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 55.0,
                  height: 55.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: kDefaultPurpleColor,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: '${DataURL.baseUrl}/$netImg',
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => CircleAvatar(
                        child: SvgPicture.asset(
                          Images.ic_person,
                          color: Colors.white,
                          height: 35.0,
                        ),
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        child: SvgPicture.asset(
                          Images.ic_person,
                          color: Colors.white,
                          height: 35.0,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 14.0,
                ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            uFirstName ?? '',
                            style: const TextStyle(
                                color: kDefaultPurpleColor,
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            uRoleName,
                            style: const TextStyle(
                                color: kDefaultBlackColor, height: 1.2),
                          ),
                        ],
                      ),
                      SvgPicture.asset(
                        Images.ic_notification,
                        fit: BoxFit.scaleDown,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CardTopCandidate(
                              onTap: () {
                                Provider.of<ValueNotifier<int>>(context,
                                        listen: false)
                                    .value = 2;
                                HomePage.tabIndexNotifier.value = 0;
                              },
                              icon: Images.ic_applied,
                              number: homePageResponse2?.appliedCount ??
                                  homePageResponse3?.appliedCount ??
                                  0,
                              label: 'Applied',
                            ),
                          ),
                          const SizedBox(
                            width: 22.0,
                          ),
                          Expanded(
                            child: CardTopCandidate(
                              onTap: () {
                                //Navigate to worked page.
                                Provider.of<ValueNotifier<int>>(context,
                                        listen: false)
                                    .value = 2;
                                HomePage.tabIndexNotifier.value = 2;
                              },
                              icon: Images.ic_worked,
                              number: homePageResponse2?.workedCount ??
                                  homePageResponse3?.workedCount ??
                                  0,
                              label: 'Worked',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 14.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CardTopCandidate(
                              onTap: () {
                                // Navigate to Booked page.
                                Provider.of<ValueNotifier<int>>(context, listen: false).value = 2;
                                HomePage.tabIndexNotifier.value = 1;
                              },
                              icon: Images.ic_booked,
                              number: homePageResponse2?.bookedCount ??
                                  homePageResponse3?.bookedCount ??
                                  0,
                              label: 'Booked',
                            ),
                          ),
                          const SizedBox(
                            width: 22.0,
                          ),
                          Expanded(
                            child: CardTopCandidate(
                              icon: Images.ic_payment,
                              amountSymbol: '₹ ',
                              number: homePageResponse2?.totalPayment ??
                                  homePageResponse3?.totalPayment ??
                                  0,
                              label: 'Payment',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 19.0,
                      ),
                      kDivider, //default divider
                      const SizedBox(
                        height: 10.0,
                      ),
                      jobsHome.isEmpty
                          ? Container()
                          : ListView.separated(
                              // controller: scrollController, //will not work because of physics!
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
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
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return const SizedBox(
                                  height: 20.0,
                                );
                              },
                            ),
                      jobsHome.isEmpty
                          ? Wrap(
                              children: const [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 130.0),
                                  child: Text(
                                    'No Jobs Found',
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Visibility(
                              visible: isVisible,
                              child: const CupertinoActivityIndicator(
                                color: kDefaultPurpleColor,
                                radius: 15.0,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: isLoadingMore,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: CupertinoActivityIndicator(
                    color: Colors.black,
                    radius: 15.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
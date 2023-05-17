import 'dart:convert';
import 'package:clg_project/UI/job_description.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/models/candidate_models/find_job_response.dart';
import 'package:clg_project/resourse/api_urls.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/candidate_side/find_job/bloc/find_job_bloc.dart';
import 'package:clg_project/ui/candidate_side/find_job/bloc/find_job_state.dart';
import 'package:clg_project/ui/candidate_side/find_job/repo/find_job_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../../../UI/widgets/job_card_home_page.dart';
import '../../../../constants.dart';
import '../../../../custom_widgets/custom_widget_helper.dart';
import '../../../../resourse/dimens.dart';
import '../../../../resourse/shared_prefs.dart';
import '../bloc/find_job_event.dart';

class FindJobPage extends StatefulWidget {
  @override
  State<FindJobPage> createState() => _FindJobPageState();
}

class _FindJobPageState extends State<FindJobPage> {
  final scrollController = ScrollController();
  bool isVisible = false;
  bool isLastPage = false;
  bool isLoadingMore = false;
  List<JobModel> jobs = [];
  int page = 1;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (page != 0) {
        // event of show find jobs
        _findJobBloc.add(ShowFindJobEvent(pageValue: page));
        setState(() {
          isLoadingMore = true;
        });
      }
    } else {
      setState(() {
        isLoadingMore = false;
      });
    }
  }

  // // Candidate find job api:
  // Future<void> findJobCandidateApi(int pageValue) async {
  //   final queryParameters = {
  //     'page': pageValue.toString(),
  //   };
  //   String url = ApiUrl.findJobCandidateApi(uId);
  //   var urlParsed = Uri.parse(url);
  //   final urlName = urlParsed.replace(queryParameters: queryParameters);
  //   try {
  //     setState(() {
  //       isVisible = true;
  //     });
  //     var response = await http.get(urlName);
  //     // log('find job log:${response.body}');
  //     if (response.statusCode == 200) {
  //       var json = jsonDecode(response.body);
  //       var findJobResponse = FindJobResponse.fromJson(json);
  //       setState(() {
  //         page = findJobResponse.lastPage!;
  //       });
  //       // pagination with url
  //       // var headerPagination = HeaderPagination.fromJson(headerDecoded);
  //       // page = headerPagination.nextPage ?? 1;
  //       // var headerDecoded =
  //       //     jsonDecode(response.headers['x-pagination'].toString());
  //       // print('HEADERS: ${response.headers['x-pagination']}');
  //       setState(() {
  //         isVisible = false;
  //         isLoadingMore = false;
  //         jobs.addAll(findJobResponse.data ?? []);
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //     setState(() {
  //       isVisible = false;
  //     });
  //   }
  //   setState(() {
  //     isVisible = false;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    // event of show find jobs
    _findJobBloc.add(ShowFindJobEvent(pageValue: page));
  }

  final _findJobBloc = FindJobBloc(FindJobRepository());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ValueNotifier<int>>(context, listen: false).value = 0;
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: Dimens.pixel_0,
          automaticallyImplyLeading: false,
        ),
        body: BlocProvider<FindJobBloc>(
          create: (BuildContext context) => _findJobBloc,
          child: BlocConsumer<FindJobBloc, FindJobState>(
            listener: (BuildContext context, state) {
              if (state is FindJobLoadingState) {
                setState(() {
                  isVisible = true;
                });
              }
              if (state is FindJobLoadedState) {
                setState(() {
                  isVisible = false;
                  isLoadingMore = false;
                });
                var responseBody = state.response;
                var findJobResponse = FindJobResponse.fromJson(responseBody);
                if (findJobResponse.code == 200) {
                  // pagination with url
                  // var headerPagination = HeaderPagination.fromJson(headerDecoded);
                  // page = headerPagination.nextPage ?? 1;
                  // var headerDecoded =
                  //     jsonDecode(response.headers['x-pagination'].toString());
                  // print('HEADERS: ${response.headers['x-pagination']}');
                  setState(() {
                    jobs.addAll(findJobResponse.data ?? []);
                    page = findJobResponse.lastPage!;
                  });
                }
              }
              if (state is FindJobErrorState) {
                debugPrint(state.error);
              }
            },
            builder: (BuildContext context, Object? state) {
              return isVisible
                  ? CustomWidgetHelper.Loader(context: context)
                  : Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            Dimens.pixel_16,
                            Dimens.pixel_0,
                            Dimens.pixel_16,
                            Dimens.pixel_0,
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleText(
                                      title: Strings.text_title_find_jobs),
                                  Expanded(
                                    child: jobs.isNotEmpty
                                        ? ListView.separated(
                                            controller: scrollController,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            padding: const EdgeInsets.only(
                                                top: Dimens.pixel_35),
                                            shrinkWrap: true,
                                            itemCount: jobs.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return InkWell(
                                                onTap: () {
                                                  int? jobId = jobs[index].id;
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          JobDescription(
                                                        jobId: jobId,
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: JobCardCandidate(
                                                  homePageModel: jobs[index],
                                                ),
                                              );
                                            },
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return const SizedBox(
                                                height: Dimens.pixel_20,
                                              );
                                            },
                                          )
                                        : Container(),
                                  ),
                                  jobs.isNotEmpty
                                      ? Visibility(
                                          visible: isLoadingMore,
                                          child: const Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: Dimens.pixel_12),
                                              child: CupertinoActivityIndicator(
                                                color: Colors.black,
                                                radius: Dimens.pixel_15,
                                              ),
                                            ),
                                          ),
                                        )
                                      : const Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: Dimens.pixel_280),
                                            child: Center(
                                              child: Text(
                                                Strings
                                                    .candidate_text_no_jobs_found,
                                                style:
                                                    kDefaultEmptyFieldTextStyle,
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }
}
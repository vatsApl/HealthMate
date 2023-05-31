import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/candidate_side/candidate_home_page/candidate_job_description/view/job_description.dart';
import 'package:clg_project/ui/candidate_side/find_job/bloc/find_job_bloc.dart';
import 'package:clg_project/ui/candidate_side/find_job/bloc/find_job_state.dart';
import 'package:clg_project/ui/candidate_side/find_job/model/find_job_response.dart';
import 'package:clg_project/ui/candidate_side/find_job/repo/find_job_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../UI/widgets/job_card_home_page.dart';
import '../../../../constants.dart';
import '../../../../custom_widgets/custom_widget_helper.dart';
import '../../../../resourse/dimens.dart';
import '../bloc/find_job_event.dart';

class FindJobPage extends StatefulWidget {
  @override
  State<FindJobPage> createState() => _FindJobPageState();
}

class _FindJobPageState extends State<FindJobPage> {
  final scrollController = ScrollController();
  bool isVisible = false;
  bool isLoadingMore = false;
  List<JobModel> jobs = [];
  int page = 1;

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (page != 0) {
        // event of show find jobs
        _findJobBloc.add(ShowFindJobEvent(pageValue: page));
        // page++;
        isLoadingMore = true;
      }
    } else {
      isLoadingMore = false;
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    // event of show find jobs
    _findJobBloc.add(ShowFindJobEvent(pageValue: page));
  }

  final _findJobBloc = FindJobBloc(FindJobRepository());

  @override
  void dispose() {
    _findJobBloc.close();
    super.dispose();
  }

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
                if (page == 1) {
                  isVisible = true;
                }
              }
              if (state is FindJobLoadedState) {
                var responseBody = state.response;
                var findJobResponse = FindJobResponse.fromJson(responseBody);
                isVisible = false;
                if (findJobResponse.code == 200) {
                  // previously used pagination with url
                  // var headerPagination = HeaderPagination.fromJson(headerDecoded);
                  // page = headerPagination.nextPage ?? 1;
                  // var headerDecoded =
                  //     jsonDecode(response.headers['x-pagination'].toString());
                  // print('HEADERS: ${response.headers['x-pagination']}');
                  page = findJobResponse.lastPage ?? 0;
                  jobs.addAll(findJobResponse.data ?? []);
                  isLoadingMore = false;
                }
              }
              if (state is FindJobErrorState) {
                debugPrint(state.error);
              }
            },
            builder: (BuildContext context, Object? state) {
              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Dimens.pixel_16,
                        ),
                        child: TitleText(title: Strings.text_title_find_jobs),
                      ),
                      Expanded(
                        child: isVisible
                            ? CustomWidgetHelper.Loader(context: context)
                            : findJobList(),
                      ),
                      if (jobs.isNotEmpty)
                        Visibility(
                          visible: isLoadingMore,
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: Dimens.pixel_16,
                              ),
                              child: CupertinoActivityIndicator(
                                color: Colors.black,
                                radius: Dimens.pixel_15,
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  findJobList() {
    return jobs.isEmpty
        ? Center(
            child: Text(
              Strings.candidate_text_no_jobs_found,
              style: kDefaultEmptyFieldTextStyle,
            ),
          )
        : ListView.separated(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              top: Dimens.pixel_35,
              left: Dimens.pixel_16,
              right: Dimens.pixel_16,
              bottom: Dimens.pixel_18,
            ),
            shrinkWrap: true,
            itemCount: jobs.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  int? jobId = jobs[index].id;
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
                  homePageModel: jobs[index],
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

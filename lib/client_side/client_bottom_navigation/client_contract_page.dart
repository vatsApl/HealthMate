import 'dart:convert';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/client_side/create_contract_page.dart';
import 'package:clg_project/client_side/job_card_client.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/client_model/client_job_res.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import '../client_job_description.dart';

class ClientContractPage extends StatefulWidget {
  const ClientContractPage({Key? key}) : super(key: key);

  @override
  State<ClientContractPage> createState() => _ClientContractPageState();
}

class _ClientContractPageState extends State<ClientContractPage> {
  final scrollController = ScrollController();
  List<JobModel> clientJobs = [];
  // List<JobModel> jobs = [];
  int page = 1;
  bool? isLastPage;
  bool isLoadingMore = false;

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (isLastPage == false) {
        showContract(page);
        page++;
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

  //show contract api:
  Future<void> showContract(int pageValue) async {
    final queryParameters = {
      'page': pageValue.toString(),
    };
    var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
    // var uId = PreferencesHelper.getInt(PreferencesHelper.KEY_USER_ID);
    var url = Uri.parse('${DataURL.baseUrl}/api/job/index/$uId/client')
        .replace(queryParameters: queryParameters);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // log(response.body);
        var json = jsonDecode(response.body);
        var clientJobResponse = ClientJobModelResponse.fromJson(json);
        isLastPage = clientJobResponse.isLastPage;
        // page = headerPagination.nextPage ?? 1;
        // print(clientJobResponse.data);
        setState(() {
          isLoadingMore = false;
          clientJobs.addAll(clientJobResponse.data ?? []);
          // jobs.addAll(clientJobResponse.data ?? []);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    showContract(page);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 19.0, 16.0, 0.0),
        child: Scaffold(
          // appBar: CustomAppBar(
          //   svgPictureLeading: Images.ic_left_arrow,
          //   onTapLeading: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const ClientMainPage(),
          //       ),
          //     );
          //   },
          // ),
          body: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TitleText(title: 'Contracts'),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateContract(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          border:
                              Border.all(width: 1.5, color: kDefaultPurpleColor),
                        ),
                        child: SvgPicture.asset(
                          Images.ic_plus,
                          height: 28.0,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: clientJobs.isNotEmpty
                      ? ListView.separated(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(top: 35.0),
                          shrinkWrap: true,
                          itemCount: clientJobs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                // int? jobId = jobs[index].id;
                                int? jobId = clientJobs[index].id;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClientJobDescription(
                                      jobId: jobId,
                                    ),
                                  ),
                                );
                              },
                              child: JobCardClient(
                                clientJobModel: clientJobs[index],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: 20.0,
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'No Contracts available',
                            style: kDefaultEmptyListStyle,
                          ),
                        ),
                ),
                clientJobs.isNotEmpty
                    ? Visibility(
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
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

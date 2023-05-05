import 'dart:convert';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/client_side/create_contract_page.dart';
import 'package:clg_project/client_side/job_card_client.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/client_model/client_job_res.dart';
import 'package:clg_project/resourse/api_urls.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import '../../resourse/app_colors.dart';
import '../../resourse/dimens.dart';
import '../client_job_description.dart';

class ClientContractPage extends BasePageScreen {
  @override
  State<ClientContractPage> createState() => _ClientContractPageState();
}

class _ClientContractPageState extends BasePageScreenState<ClientContractPage>
    with BaseScreen {
  final scrollController = ScrollController();
  List<JobModel> clientJobs = [];
  int page = 1;
  bool? isLastPage;
  bool isLoadingMore = false;

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (isLastPage == false) {
        showContractApi(page);
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
  Future<void> showContractApi(int pageValue) async {
    final queryParameters = {
      'page': pageValue.toString(),
    };
    var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
    String url = ApiUrl.showContractApi(uId);
    try {
      var response = await http.get(
        Uri.parse(url).replace(queryParameters: queryParameters),
      );
      // log('contract page log:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var clientJobResponse = ClientJobModelResponse.fromJson(json);
        isLastPage = clientJobResponse.isLastPage;
        setState(() {
          isLoadingMore = false;
          clientJobs.addAll(clientJobResponse.data ?? []);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    isBackButton(false);
    scrollController.addListener(scrollListener);
    showContractApi(page);
  }

  @override
  Widget body() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimens.pixel_16,
        Dimens.pixel_0,
        Dimens.pixel_16,
        Dimens.pixel_0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleText(title: Strings.text_contracts),
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
                    borderRadius: BorderRadius.circular(
                      Dimens.pixel_50,
                    ),
                    border: Border.all(
                      width: Dimens.pixel_1_and_half,
                      color: AppColors.kDefaultPurpleColor,
                    ),
                  ),
                  child: SvgPicture.asset(
                    Images.ic_plus,
                    height: Dimens.pixel_28,
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
                    padding: const EdgeInsets.only(
                      top: Dimens.pixel_35,
                    ),
                    shrinkWrap: true,
                    itemCount: clientJobs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
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
                        height: Dimens.pixel_20,
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      Strings.text_no_contracts_available,
                      style: kDefaultEmptyListStyle,
                    ),
                  ),
          ),
          clientJobs.isNotEmpty
              ? Visibility(
                  visible: isLoadingMore,
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimens.pixel_12,
                      ),
                      child: CupertinoActivityIndicator(
                        color: Colors.black,
                        radius: Dimens.pixel_15,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/job_card_with_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../allAPIs/allAPIs.dart';
import '../../constants.dart';
import '../../models/candidate_models/find_job_response.dart';
import '../../resourse/api_urls.dart';
import '../../resourse/images.dart';
import '../../resourse/shared_prefs.dart';
import 'package:http/http.dart' as http;
import '../../widgets/elevated_button.dart';

class Invoices extends StatefulWidget {

  @override
  State<Invoices> createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  bool isLoadingMore = false;
  int page = 1;
  final scrollController = ScrollController();
  List<JobModel> jobs = [];
  int? invoiceId;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (page != 0) {
        timesheetJobApi(page);
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

  // Invoice api:
  Future<void> timesheetJobApi(int pageValue) async {
    final queryParameters = {
      'page': pageValue.toString(),
    };
    try {
      setState(() {
        isLoadingMore = true;
      });
      String url = ApiUrl.clientVerificationsPageApi;
      var response = await http.post(
          Uri.parse(url)
              .replace(queryParameters: queryParameters),
          body: {
            'id': uId,
            'status': '3',
          });
      log('invoice res:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        var timesheetJobResponse = FindJobResponse.fromJson(json);
        print('${json['message']}');
        setState(() {
          isLoadingMore = false;
          page = timesheetJobResponse.lastPage!;
          jobs.addAll(timesheetJobResponse.data ?? []);
        });
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //mark as paid popup: showDialogMarkAsPaid
  Future<void> showDialogMarkAsPaid() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 12.0,
                    ),
                    SvgPicture.asset(
                      Images.ic_success_popup,
                      color: kDefaultPurpleColor,
                      fit: BoxFit.scaleDown,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Text(
                      'Mark As Paid',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: kDefaultPurpleColor,
                      ),
                    ),
                    const SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      'Are You Sure You Want To Mark As Paid',
                      style: const TextStyle(color: kDefaultBlackColor)
                          .copyWith(height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 38.0,
                          width: 120.0,
                          child: ElevatedBtn(
                            btnTitle: 'No',
                            textColor: klabelColor,
                            bgColor: const Color(0xffE1E1E1),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        const SizedBox(width: 17.0,),
                        SizedBox(
                          height: 38.0,
                          width: 120.0,
                          child: ElevatedBtn(
                            btnTitle: 'Yes',
                            bgColor: kDefaultPurpleColor,
                            onPressed: () {
                              markAsPaidApi();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //mark as paid api:
  Future<void> markAsPaidApi() async {
    try {
      // setState(() {
      //   isLoadingMore = true;
      // });
      var response = await http.post(
          Uri.parse('${DataURL.baseUrl}/api/mark/as/paid'),
          body: {
            'invoice_id': invoiceId.toString(),
          });
      log('invoice res:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        print('${json['message']}');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    timesheetJobApi(page);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: jobs.isNotEmpty ?
      ListView.separated(
        physics: const BouncingScrollPhysics(),
        controller: scrollController,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: jobs.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              invoiceId = jobs[index].invoiceId;
              if(jobs[index].jobStatus != 'Paid')
                showDialogMarkAsPaid();
            },
            child: JobCardWithStatus(
              jobModel: jobs[index],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 20.0,
          );
        },
      ) : const Center(
        child: Text(
          'No Invoices',
          style: kDefaultEmptyListStyle,
        ),
      ),
    );
  }
}

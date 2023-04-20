import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/client_card_top.dart';
import 'package:clg_project/UI/widgets/custom_appbar.dart';
import 'package:clg_project/client_side/create_contract_page.dart';
import 'package:clg_project/client_side/job_card_client.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/client_model/client_job_res.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../allAPIs/allAPIs.dart';
import '../../custom_widgets/index_notifier.dart';
import '../client_job_description.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({Key? key}) : super(key: key);
  static ValueNotifier tabIndexNotifier = TabIndexNotifier();

  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  List<JobModel> clientJobs = [];
  var clientJobResponse;
  var clientJobResponse2;
  bool isVisible = false;
  int page = 1;
  String? clientName = PreferencesHelper.getString(PreferencesHelper.KEY_CLIENT_NAME);
  String? netImg = PreferencesHelper.getString(PreferencesHelper.KEY_CLIENT_AVATAR);
  //client home page api
  Future<void> showContractHome(int pageValue) async {
    var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
    var url = Uri.parse('${DataURL.baseUrl}/api/job/index/$uId/client');
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.get(url);
      log('client home res:${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        clientJobResponse = ClientJobModelResponse.fromJson(json);
        clientJobResponse2 = ClientJobModelResponse.fromJson(json);
        print(clientJobResponse2.contractCount);
        setState(() {
          isVisible = false;
          clientJobs.addAll(clientJobResponse.data ?? []);
        });
      }
    } catch (e) {
      setState(() {
        isVisible = false;
      });
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    showContractHome(page);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 19.0, 16.0, 0.0),
      child: Scaffold(
        appBar: CustomAppBar(
          name: clientName,
          svgPictureTrailing: Images.ic_notification,
          netImg: netImg,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     SizedBox(
            //       width: 55.0,
            //       height: 55.0,
            //       child: CircleAvatar(
            //         child: netImg == 'null'
            //             ? SvgPicture.asset(
            //                 Images.ic_person,
            //                 color: Colors.white,
            //                 height: 30.0,
            //               )
            //             : Container(
            //                 decoration: BoxDecoration(
            //                   shape: BoxShape.circle,
            //                   image: DecorationImage(
            //                     image:
            //                         NetworkImage('${DataURL.baseUrl}/$netImg'),
            //                     fit: BoxFit.cover,
            //                   ),
            //                 ),
            //               ),
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 14.0,
            //     ),
            //     Expanded(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 clientName,
            //                 style: const TextStyle(
            //                     color: kDefaultPurpleColor,
            //                     fontSize: 18.0,
            //                     fontWeight: FontWeight.w700),
            //               ),
            //               // const Text(
            //               //   'role',
            //               //   style: TextStyle(
            //               //       color: kDefaultBlackColor, height: 1.2),
            //               // ),
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
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CardTopClient(
                            onTap: () {
                              //Navigate to contracts page.
                              Provider.of<ValueNotifier<int>>(context,
                                      listen: false)
                                  .value = 1;
                              // ClientHomePage.tabIndexNotifier.value = 0;
                            },
                            icon: Images.ic_contracts_circle,
                            number: clientJobResponse2?.contractCount ?? 0,
                            label: 'Contracts',
                          ),
                          const SizedBox(
                            width: 22.0,
                          ),
                          CardTopClient(
                            onTap: () {
                              //Navigate to Timesheet page.
                              Provider.of<ValueNotifier<int>>(context,
                                      listen: false)
                                  .value = 2;
                              ClientHomePage.tabIndexNotifier.value = 1;
                            },
                            icon: Images.ic_timesheet,
                            number: clientJobResponse2?.timesheetCount ?? 0,
                            label: 'Timesheets',
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 14.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CardTopClient(
                            onTap: () {
                              //Navigate to approvals page.
                              Provider.of<ValueNotifier<int>>(context,
                                      listen: false)
                                  .value = 2;
                              ClientHomePage.tabIndexNotifier.value = 0;
                            },
                            icon: Images.ic_approvals_2,
                            number: clientJobResponse2?.invoiceCount ?? 0,
                            label: 'Approvals',
                          ),
                          const SizedBox(
                            width: 22.0,
                          ),
                          CardTopClient(
                            onTap: () {
                              //Navigate to Invoice page.
                              Provider.of<ValueNotifier<int>>(context,
                                      listen: false)
                                  .value = 2;
                              ClientHomePage.tabIndexNotifier.value = 2;
                            },
                            icon: Images.ic_payment,
                            number: clientJobResponse2?.allPayment ?? 0,
                            label: 'Invoices',
                            amountSymbol: '₹ ',
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 34.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 3.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: SizedBox(
                            width: 130.0,
                            height: 30.0,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreateContract(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: kDefaultPurpleColor),
                              icon: SvgPicture.asset(
                                Images.ic_plus,
                                color: Colors.white,
                              ),
                              label: Row(
                                children: const [
                                  Text(
                                    'Create',
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 2.0,
                                  ),
                                  Text(
                                    'Contract',
                                    style: TextStyle(
                                        fontSize: 10.0,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(
                      //   height: 20.0,
                      // ),
                      clientJobs.isEmpty
                          ? Container()
                          : ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(top: 30.0),
                              shrinkWrap: true,
                              // itemCount: 10,
                              itemCount: clientJobs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    int? jobId = clientJobs[index].id;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ClientJobDescription(jobId: jobId),
                                      ),
                                    );
                                  },
                                  child: JobCardClient(
                                    clientJobModel: clientJobs[index],
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
                      clientJobs.isNotEmpty
                          ? Visibility(
                              visible: isVisible,
                              child: const CupertinoActivityIndicator(
                                color: kDefaultPurpleColor,
                                radius: 15.0,
                              ),
                            )
                          : Wrap(
                              children: const [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 130.0),
                                  child: Text(
                                    'No Contracts available',
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

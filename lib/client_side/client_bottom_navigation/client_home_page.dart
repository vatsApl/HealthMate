import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/client_card_top.dart';
import 'package:clg_project/UI/widgets/custom_appbar.dart';
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
import 'package:provider/provider.dart';
import '../../custom_widgets/index_notifier.dart';
import '../../resourse/app_colors.dart';
import '../../resourse/dimens.dart';
import '../client_job_description.dart';

class ClientHomePage extends StatefulWidget {
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
  String? clientName =
      PreferencesHelper.getString(PreferencesHelper.KEY_CLIENT_NAME);
  String? netImg =
      PreferencesHelper.getString(PreferencesHelper.KEY_CLIENT_AVATAR);

  //client home page api
  Future<void> showContractHomeApi(int pageValue) async {
    var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
    String url = ApiUrl.showContractHomeApi(uId);
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.get(Uri.parse(url));
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
    showContractHomeApi(page);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Dimens.pixel_16, Dimens.pixel_19, Dimens.pixel_16, Dimens.pixel_0),
      child: Scaffold(
        appBar: CustomAppBar(
          name: clientName,
          svgPictureTrailing: Images.ic_notification,
          netImg: netImg,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(top: Dimens.pixel_48),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: CardTopClient(
                              onTap: () {
                                // Navigate to contracts page.
                                Provider.of<ValueNotifier<int>>(context,
                                        listen: false)
                                    .value = 1;
                              },
                              icon: Images.ic_contracts_circle,
                              number: clientJobResponse2?.contractCount ?? 0,
                              label: Strings.text_contracts,
                            ),
                          ),
                          const SizedBox(
                            width: Dimens.pixel_22,
                          ),
                          Expanded(
                            flex: 1,
                            child: CardTopClient(
                              onTap: () {
                                //Navigate to Timesheet page.
                                Provider.of<ValueNotifier<int>>(context,
                                        listen: false)
                                    .value = 2;
                                ClientHomePage.tabIndexNotifier.value = 1;
                              },
                              icon: Images.ic_timesheet,
                              number: clientJobResponse2?.timesheetCount ?? 0,
                              label: Strings.text_timesheets,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: Dimens.pixel_14,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CardTopClient(
                              onTap: () {
                                //Navigate to approvals page.
                                Provider.of<ValueNotifier<int>>(context,
                                        listen: false)
                                    .value = 2;
                                ClientHomePage.tabIndexNotifier.value = 0;
                              },
                              icon: Images.ic_approvals_2,
                              number: clientJobResponse2?.invoiceCount ?? 0,
                              label: Strings.text_approvals,
                            ),
                          ),
                          const SizedBox(
                            width: Dimens.pixel_22,
                          ),
                          Expanded(
                            child: CardTopClient(
                              onTap: () {
                                //Navigate to Invoice page.
                                Provider.of<ValueNotifier<int>>(context,
                                        listen: false)
                                    .value = 2;
                                ClientHomePage.tabIndexNotifier.value = 2;
                              },
                              icon: Images.ic_payment,
                              number: clientJobResponse2?.allPayment ?? 0,
                              label: Strings.text_invoices,
                              amountSymbol: Strings.amount_symbol_rupee,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: Dimens.pixel_34,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateContract(),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                Dimens.pixel_14,
                                Dimens.pixel_10,
                                Dimens.pixel_10,
                                Dimens.pixel_10),
                            decoration: BoxDecoration(
                              color: AppColors.kDefaultPurpleColor,
                              borderRadius:
                                  BorderRadius.circular(Dimens.pixel_6),
                            ),
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    Images.ic_plus,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: Dimens.pixel_10,
                                  ),
                                  Text(
                                    Strings.text_create_contract,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: Dimens.pixel_10,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      clientJobs.isEmpty
                          ? Container()
                          : ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets.only(top: Dimens.pixel_30),
                              shrinkWrap: true,
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
                                  height: Dimens.pixel_20,
                                );
                              },
                            ),
                      clientJobs.isNotEmpty
                          ? Visibility(
                              visible: isVisible,
                              child: const CupertinoActivityIndicator(
                                color: AppColors.kDefaultPurpleColor,
                                radius: Dimens.pixel_15,
                              ),
                            )
                          : Wrap(
                              children: const [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: Dimens.pixel_130),
                                  child: Text(
                                    Strings.text_no_contracts_available,
                                    style: TextStyle(
                                      fontSize: Dimens.pixel_22,
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

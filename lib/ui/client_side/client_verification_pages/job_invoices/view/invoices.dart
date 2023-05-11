import 'dart:convert';
import 'dart:developer';
import 'package:clg_project/UI/widgets/job_card_with_status.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/client_side/client_verification_pages/job_invoices/bloc/invoice_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../constants.dart';
import '../../../../../models/candidate_models/find_job_response.dart';
import 'package:http/http.dart' as http;
import '../../../../../resourse/api_urls.dart';
import '../../../../../resourse/app_colors.dart';
import '../../../../../resourse/dimens.dart';
import '../../../../../resourse/images.dart';
import '../../../../../resourse/shared_prefs.dart';
import '../../../../../widgets/elevated_button.dart';
import '../bloc/invoice_bloc.dart';
import '../bloc/invoice_event.dart';
import '../repo/invoice_repository.dart';

class Invoices extends StatefulWidget {
  @override
  State<Invoices> createState() => _InvoicesState();
}

class _InvoicesState extends State<Invoices> {
  bool isLoadingMore = false;
  bool isVisible = false;
  int page = 1;
  final scrollController = ScrollController();
  List<JobModel> jobs = [];
  int? invoiceId;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (page != 0) {
        // event show invoices
        _invoiceBloc.add(ShowInvoiceEvent(
          pageValue: page,
          status: '3',
        ));
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

  Future<void> showDialogMarkAsPaid() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: Dimens.pixel_16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Dimens.pixel_6,
            ),
          ),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Dimens.pixel_10,
                  vertical: Dimens.pixel_25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: Dimens.pixel_12,
                    ),
                    SvgPicture.asset(
                      Images.ic_success_popup,
                      color: AppColors.kDefaultPurpleColor,
                      fit: BoxFit.scaleDown,
                    ),
                    const SizedBox(
                      height: Dimens.pixel_20,
                    ),
                    const Text(
                      Strings.text_mark_As_paid,
                      style: TextStyle(
                        fontSize: Dimens.pixel_18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.kDefaultPurpleColor,
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_12,
                    ),
                    Text(
                      Strings.text_confirmation_of_mark_As_paid,
                      style: const TextStyle(
                        color: AppColors.kDefaultBlackColor,
                      ).copyWith(
                        height: Dimens.pixel_1_and_half,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: Dimens.pixel_30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: Dimens.pixel_38,
                          width: Dimens.pixel_120,
                          child: ElevatedBtn(
                            btnTitle: Strings.text_no,
                            textColor: AppColors.klabelColor,
                            bgColor: const Color(0xffE1E1E1),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        const SizedBox(
                          width: Dimens.pixel_17,
                        ),
                        SizedBox(
                          height: Dimens.pixel_38,
                          width: Dimens.pixel_120,
                          child: ElevatedBtn(
                            btnTitle: Strings.text_yes,
                            bgColor: AppColors.kDefaultPurpleColor,
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
      String url = ApiUrl.markAsPaidApi;
      var response = await http.post(Uri.parse(url), body: {
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
    // event of show invoices
    _invoiceBloc.add(ShowInvoiceEvent(
      pageValue: page,
      status: '3',
    ));
  }

  final _invoiceBloc = InvoiceBloc(InvoiceRepository());

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InvoiceBloc>(
      create: (BuildContext context) => _invoiceBloc,
      child: BlocConsumer<InvoiceBloc, InvoiceState>(
        listener: (BuildContext context, state) {
          if (state is InvoiceLoadingState) {
            if (page == 1) {
              setState(() {
                isVisible = true;
              });
            }
          }
          if (state is InvoiceLoadedState) {
            var responseBody = state.response;
            var invoiceJobResponse = FindJobResponse.fromJson(responseBody);
            if (invoiceJobResponse.code == 200) {
              setState(() {
                page = invoiceJobResponse.lastPage!;
                jobs.addAll(invoiceJobResponse.data ?? []);
                isLoadingMore = false;
                isVisible = false;
              });
            }
          }
        },
        builder: (BuildContext context, Object? state) {
          return Flexible(
            child: isVisible
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : invoiceList(),
          );
        },
      ),
    );
  }

  invoiceList() {
    return jobs.isNotEmpty
        ? SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            child: Column(
              children: [
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  // controller: scrollController,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: jobs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        invoiceId = jobs[index].invoiceId;
                        if (jobs[index].jobStatus != 'Paid')
                          showDialogMarkAsPaid();
                      },
                      child: JobCardWithStatus(
                        jobModel: jobs[index],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: Dimens.pixel_20,
                    );
                  },
                ),
                if (jobs.isNotEmpty)
                  Visibility(
                    visible: isLoadingMore,
                    child: Center(
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
                  ),
              ],
            ),
          )
        : const Center(
            child: Text(
              Strings.text_no_invoices,
              style: kDefaultEmptyFieldTextStyle,
            ),
          );
  }
}
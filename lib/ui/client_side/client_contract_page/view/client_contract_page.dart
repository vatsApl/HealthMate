import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/client_side/client_contract_page/bloc/client_contract_bloc.dart';
import 'package:clg_project/ui/client_side/client_contract_page/bloc/client_contract_state.dart';
import 'package:clg_project/ui/client_side/client_home_page/model/client_job_res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../custom_widgets/custom_widget_helper.dart';
import '../../../../resourse/app_colors.dart';
import '../../../../resourse/dimens.dart';
import '../../client_home_page/client_job_description/view/client_job_description.dart';
import '../../create_contract/view/create_contract_page.dart';
import '../../job_cards/job_card_client.dart';
import '../bloc/client_contract_event.dart';
import '../repo/client_contract_repository.dart';

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
  var clientJobResponse;
  bool isVisible = false;
  bool isLoadingMore = false;

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (isLastPage == false) {
        // event of show contract
        _clientContractBloc.add(ClientContractLoadEvent(page));
        page++;
        isLoadingMore = true;
      }
    } else {
      isLoadingMore = false;
    }
  }

  @override
  void initState() {
    super.initState();
    isBackButton(false);
    scrollController.addListener(scrollListener);
    // event of load contract api
    _clientContractBloc.add(ClientContractLoadEvent(page));
  }

  final _clientContractBloc = ClientContractBloc(ClientContractRepository());

  @override
  Widget body() {
    return BlocProvider<ClientContractBloc>(
      create: (BuildContext context) => _clientContractBloc,
      child: BlocConsumer<ClientContractBloc, ClientContractState>(
        listener: (BuildContext context, state) {
          if (state is ClientContractLoadingState) {
            if (page == 1) {
              isVisible = true;
            }
          }
          if (state is ClientContractLoadedState) {
            var responseBody = state.response;
            clientJobResponse = ClientJobModel.fromJson(responseBody);
            if (clientJobResponse.code == 200) {
              isLastPage = clientJobResponse.isLastPage;
              print('contract page isLastpage:$isLastPage');
              isVisible = false;
              isLoadingMore = false;
              clientJobs.addAll(clientJobResponse.data ?? []);
            }
          }
        },
        builder: (BuildContext context, Object? state) {
          return WillPopScope(
            onWillPop: () async {
              Provider.of<ValueNotifier<int>>(context, listen: false).value = 0;
              return false;
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Dimens.pixel_16,
                  ),
                  child: Row(
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
                ),
                Expanded(
                  child: isVisible
                      ? CustomWidgetHelper.Loader(context: context)
                      : contractsList(),
                ),
                if (clientJobs.isNotEmpty)
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
          );
        },
      ),
    );
  }

  Widget contractsList() {
    return clientJobs.isNotEmpty
        ? ListView.separated(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              top: Dimens.pixel_35,
              left: Dimens.pixel_16,
              right: Dimens.pixel_16,
              bottom: Dimens.pixel_18,
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
              style: kDefaultEmptyFieldTextStyle,
            ),
          );
  }
}

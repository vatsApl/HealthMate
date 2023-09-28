import 'package:clg_project/UI/message/bloc/message_bloc.dart';
import 'package:clg_project/UI/message/bloc/message_event.dart';
import 'package:clg_project/UI/message/bloc/message_state.dart';
import 'package:clg_project/UI/message/model/candidate_chat_list_model.dart';
import 'package:clg_project/UI/message/repo/message_repository.dart';
import 'package:clg_project/UI/message/view/chat_screen.dart';
import 'package:clg_project/UI/message/view/message_list_tile.dart';
import 'package:clg_project/UI/widgets/custom_loader.dart';
import 'package:clg_project/UI/widgets/custom_textfield.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/helper/socket_io_client.dart';
import 'package:clg_project/resourse/app_colors.dart';
import 'package:clg_project/resourse/dimens.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageListPage extends BasePageScreen {
  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  String? appBarTitle = 'Message';
  TextEditingController searchController = TextEditingController();

  final _messageBloc = MessageBloc(MessageRepository());
  bool isLoading = false;
  List<CandidateChatListData?> candidateChatListData = [];

  final scrollController = ScrollController();
  int page = 1;
  bool? isLastPage;
  bool isLoadingMore = false;

  void scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (isLastPage == false) {
        // event of show contract
        _messageBloc.add(ShowMessageListEvent2(page));
        isLoadingMore = true;
      }
    } else {
      isLoadingMore = false;
    }
  }

  int? userType = PreferencesHelper.getInt(PreferencesHelper.KEY_USER_TYPE);
  @override
  void initState() {
    scrollController.addListener(scrollListener);
    _messageBloc.add(ShowMessageListEvent2(page));
    debugPrint('user_type from shared preference: ${userType}');
    // socket initialize
    // SocketUtilsClient.instance.initSocket();
    SocketUtilsClient.instance.connectToSocket();
    // SocketUtils.instance.setConnectListener(onConnect);
    SocketUtilsClient.instance.setConnectingListener(onConnecting);
    SocketUtilsClient.instance.setOnDisconnectListener(onDisconnect);
    SocketUtilsClient.instance.reconnectAttempt(onReConnect);
    SocketUtilsClient.instance.setOnErrorListener(onError);
    SocketUtilsClient.instance.setOnConnectionErrorListener(onConnectError);
    SocketUtilsClient.instance.setOnPingListener(onConnectAgain);
    super.initState();
  }

  onConnecting(data) {
    print('Connecteing $data');
  }

  onDisconnect(data) {
    print('onDisconnect $data');
  }

  onReConnect(data) {
    print("onReConnect$data");
    SocketUtilsClient.instance.connectToSocket();
  }

  onError(data) async {
    print('onError $data');
    if (data == "errorrr:{message: Not Authorised}") {
      await SocketUtilsClient.instance.initSocket();
    }
  }

  onConnectError(data) {
    print('onConnectError $data');
  }

  onConnectAgain() {
    SocketUtilsClient.instance.connectToSocket();
  }

  @override
  void dispose() {
    // SocketUtils.instance.disposeSocket();
    candidateChatListData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MessageBloc>(
      create: (BuildContext context) => _messageBloc,
      child: BlocConsumer<MessageBloc, MessageState>(
        listener: (BuildContext context, state) {
          if (state is MessageLoadingState) {
            setState(() {
              isLoading = true;
            });
          } else if (state is MessageLoadedState) {
            setState(() {
              isLoading = false;
              isLoadingMore = false;
            });
            var responseBody = state.response;
            var candidateChatListResponse =
                CandidateChatListModel.fromJson(responseBody);
            if (candidateChatListResponse.code == 200) {
              isLastPage = candidateChatListResponse.isLastPage;
              page = candidateChatListResponse.nextPage;
              // if (isLastPage == true) {
              //   candidateChatListData = [];
              // }
              candidateChatListData
                  .addAll(candidateChatListResponse.data ?? []);
              print(
                  'firstname for chat: ${candidateChatListData[0]?.firstName}');
            }
          } else if (state is MessageErrorState) {
            //
          }
        },
        builder: (BuildContext context, state) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              elevation: 0,
              flexibleSpace: Container(
                color: AppColors.themeColor,
              ),
              title: Text(
                appBarTitle == null ? "" : '$appBarTitle',
                style: kAppBarTextStyle,
              ),
              titleSpacing: Dimens.pixel_16,
              titleTextStyle: kMedium16TextStyle,
              // leading:
              // widget.isFrom == Strings.IS_FROM_TAB
              //     ? null :
              // MyIconButton(
              //     onPressed: () {
              //       Navigator.of(context).maybePop();
              //     },
              //     child: SvgLoader.load(Images.ic_white_back)),

              /*actions: [
                    CupertinoButton(
                      onPressed: onClickRightButton,
                      child: Center(
                        child: ValueListenableBuilder(
                            valueListenable: hiding.visible,
                            builder: (context, bool value, child) => Text(
                                  value ? Strings.edit : Strings.lbl_done,
                                  style: Styles.medium14TextStyle
                                      .copyWith(color: AppColors.white),
                                )),
                      ),
                    )
                  ],*/
            ),
            body: Stack(children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.zero,
                      color: AppColors.white,
                      child: _buildSearchBox(),
                    ),
                    // WidgetUtil.spaceVertical(Dimens.pixel_15),
                    SizedBox(
                      height: Dimens.pixel_15,
                    ),
                    Flexible(
                      child: ListView.builder(
                          controller: scrollController,
                          itemCount: candidateChatListData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatScreenPage(
                                      candidateChatListData:
                                          candidateChatListData[index],
                                    ),
                                  ),
                                );
                              },
                              child: MessageListTile(
                                candidateChatListData:
                                    candidateChatListData[index],
                              ),
                            );
                          }),
                    ),
                    Visibility(
                      child: CustomLoader(
                        isVisible: isLoadingMore,
                      ),
                    ),

                    // Expanded(
                    //     flex: 1,
                    //     child:
                    //         // (_searchResult.length != 0) ||
                    //         searchController.text.isNotEmpty
                    //             ? _buildSearchList()
                    //             : _buildMessageListFromDB()),
                  ],
                ),
              ),
              // CustomLoader(isVisible: isLoading)
            ]),
          );
        },
      ),
    );
  }

  ///SearchBoxView
  Widget _buildSearchBox() {
    return Padding(
      padding: EdgeInsets.only(
          left: Dimens.pixel_16, top: Dimens.pixel_24, right: Dimens.pixel_16),
      child: SearchCustomEditText(
        isDone: true,
        onSuffixIconTap: () {
          // searchController.clear();
          // onSearchTextChanged('');
          // HideKeyboard.hideKeyboard();
        },
        onTextChanged: onSearchTextChanged,
        textInputType: TextInputType.text,
        hintText: Strings.lbl_search,
        textEditingController: searchController,
      ),
    );
  }

  ///SearchListView
  Widget _buildSearchList() {
    print("isFromSearch");
    // if (_searchResult.isEmpty) {
    //   addListFromDB();
    // }
    // print("Lengthhhh${_searchResult.length == 0}");
    return
        // _searchResult.length == 0 && searchController.text.isNotEmpty == true
        //   ? cardEmptyView() :
        ListView.builder(
      // itemCount: _searchResult.length,
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        // return listOfDBConversation(
        //     _searchResult[index].users, _searchResult[index]);
        // return MessageListTile();
      },
    );

    return Container();
  }

  ///MessageListWithDBValue
  // Widget _buildMessageListFromDB() {
  //   /*  print("isFromMessageDB");
  //   print("Boxvalue:${box?.values}");
  //   print(listOFdBDepartment.isEmpty);
  //   if (box?.values.isEmpty == true) {
  //     connectDB();
  //   }
  //   if (listOFdBDepartment.isEmpty && box?.values.isNotEmpty == true) {
  //     addListFromDB();
  //   }
  //   return box?.values != null
  //       ? ValueListenableBuilder<Box<DataDB>>(
  //           valueListenable: Hive.box<DataDB>(Strings.dataDB).listenable(),
  //           builder: (context, value, child) {
  //             for (var value in listOFdBDepartment) {
  //               if (value.Selected == true) {
  //                 selectedRowCount.add(value);
  //               } else {
  //                 selectedRowCount.remove(value);
  //               }
  //             }
  //             return ListView.builder(
  //               itemCount: listOFdBDepartment.length,
  //               shrinkWrap: true,
  //               physics: BouncingScrollPhysics(),
  //               itemBuilder: (context, index) {
  //                 return listOfDBConversation(listOFdBDepartment[index].users,
  //                     listOFdBDepartment[index]);
  //               },
  //             );
  //           })
  //       : SizedBox();*/
  //
  //   return ListView.builder(
  //     // itemCount: listOFdBDepartment.length,
  //     itemCount: 5,
  //     shrinkWrap: true,
  //     physics: BouncingScrollPhysics(),
  //     itemBuilder: (context, index) {
  //       return ();
  //     },
  //   );
  // }

  ///SearchTextChanged
  onSearchTextChanged(String mText) async {
    var text = mText.replaceAll(".", "");

    // _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    // listOFdBDepartment.forEach((userDetail) {
    //   print(
    //       "${userDetail.users.firstname!.toLowerCase() + userDetail.users.lastname!.toLowerCase()}"
    //           .contains(text.toLowerCase()));
    //   print(userDetail.department.toLowerCase().contains(text.toLowerCase()));
    //   print(userDetail.users.lastname!
    //       .toLowerCase()
    //       .contains(text.toLowerCase()));
    //   if ((userDetail.department.toLowerCase().contains(text.toLowerCase()) &&
    //       userDetail.department
    //           .toLowerCase()
    //           .startsWith(text.toLowerCase())) ||
    //       "${userDetail.users.firstname!.toLowerCase()}"
    //           " ${userDetail.users.lastname!.toLowerCase()}"
    //           .contains(text.toLowerCase()) ||
    //       (userDetail.users.firstname!
    //           .toLowerCase()
    //           .contains(text.toLowerCase()) &&
    //           userDetail.users.firstname!
    //               .toLowerCase()
    //               .startsWith(text.toLowerCase())) ||
    //       (userDetail.users.lastname!
    //           .toLowerCase()
    //           .contains(text.toLowerCase()) &&
    //           userDetail.users.lastname!
    //               .toLowerCase()
    //               .startsWith(text.toLowerCase())))
    //     _searchResult.add(userDetail);
    // });
    // print(_searchResult.length);

    setState(() {});
  }
}

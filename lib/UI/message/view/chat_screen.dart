import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clg_project/UI/message/model/candidate_chat_list_model.dart';
import 'package:clg_project/UI/message/model/chat_history_model.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/custom_widgets/image_ext.dart';
import 'package:clg_project/custom_widgets/widget_util.dart';
import 'package:clg_project/helper/socket_io_client.dart';
import 'package:clg_project/resourse/app_colors.dart';
import 'package:clg_project/resourse/dimens.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatScreenPage extends BasePageScreen {
  CandidateChatListData? candidateChatListData;
  ChatScreenPage({required this.candidateChatListData});
  @override
  State<ChatScreenPage> createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends State<ChatScreenPage> {
  TextEditingController _messageController = TextEditingController();
  List<String> messages = [];
  ChatModel? chatModel;
  late int receiverId;

  @override
  void initState() {
    super.initState();
    receiverId = int.parse('${widget.candidateChatListData?.id}');
    // SocketUtilsClient.instance.listenMessages(newMessage);
    SocketUtilsClient.instance.setNotifyNewMessageListner(newMessage);
  }

  newMessage(data) {
    print('Callback data: ${data}');
    chatModel = ChatModel.fromJson(data);
    if (chatModel?.senderId ==
        int.parse(PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID))) {
      if (mounted)
        setState(() {
          messages.add(chatModel?.message ?? '');
        });
    }
    debugPrint('receiver id: ${widget.candidateChatListData?.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        //  leadingWidth: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          icon: Icon(Icons.arrow_back_outlined),
          // child: SvgLoader.load(
          //   Icons.arrow_back ?? Images.back_light,
          // ),
        ),
        centerTitle: false,
        backgroundColor: AppColors.themeColor,
        title: Container(
          padding: EdgeInsets.symmetric(vertical: Dimens.pixel_20),
          child: Row(
            children: [
              //   WidgetUtil.spaceHorizontal(Dimens.pixel_16),
              ClipRRect(
                borderRadius: BorderRadius.circular(27),
                child: CachedNetworkImage(
                  imageUrl:
                      '${DataURL.baseUrl}/${widget.candidateChatListData?.avatar}',
                  width: Dimens.pixel_48,
                  height: Dimens.pixel_48,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      //  (imageSting.isEmpty) ?  (index) ? Image.asset(imageSting): Image.network(imageSting) :
                      SvgLoader.load(Images.profile),
                  errorWidget: (context, url, error) => ClipRRect(
                    borderRadius: BorderRadius.circular(27),
                    child: Align(
                      alignment: Alignment(-1, -0.1),
                      child: SizedBox(
                        width: Dimens.pixel_48,
                        height: Dimens.pixel_48,
                        child: SvgLoader.load(Images.profile),
                      ),
                    ),
                  ),
                ),
              ),
              WidgetUtil.spaceHorizontal(Dimens.pixel_12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    PreferencesHelper.getInt(PreferencesHelper.KEY_USER_TYPE) ==
                            2
                        ? '${widget.candidateChatListData?.practiceName}'
                        : '${widget.candidateChatListData?.firstName} ${widget.candidateChatListData?.lastName}',
                    style:
                        medium16TextStyle.copyWith(color: AppColors.colorWhite),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    // "${getStatus()}",
                    'getStatus',
                    style: regular12TextStyle.copyWith(
                        color: AppColors.colorWhite),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: ListView.separated(
            padding: EdgeInsets.symmetric(
                horizontal: Dimens.pixel_16, vertical: Dimens.pixel_10),
            itemBuilder: (BuildContext context, int index) {
              return Align(
                alignment: Alignment.centerLeft,
                child: UnconstrainedBox(
                  child: Container(
                    padding: EdgeInsets.all(Dimens.pixel_10),
                    decoration: BoxDecoration(
                        color: AppColors.lightBlueLight.withOpacity(0.2),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(Dimens.pixel_15),
                          bottomLeft: Radius.circular(Dimens.pixel_15),
                          topRight: Radius.circular(Dimens.pixel_15),
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              messages[index],
                              style: medium16TextStyle.copyWith(
                                  color: AppColors.colorBlack),
                            ),
                          ],
                        ),
                        WidgetUtil.spaceVertical(Dimens.pixel_5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              DateFormat('hh:mm a').format(
                                DateTime.now(),
                              ),
                              style: medium12TextStyle.copyWith(
                                  fontSize: Dimens.pixel_11),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return WidgetUtil.spaceVertical(Dimens.pixel_10);
            },
            itemCount: messages.length),
      ),
      bottomNavigationBar: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.pixel_16,
            vertical: Dimens.pixel_10,
          ),
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            controller: _messageController,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: Strings.lbl_type_something,
              border: InputBorder.none,
              filled: true,
              fillColor: AppColors.greyCornerBg,
              prefixIcon: Icon(Icons.add_outlined),
              suffixIcon: GestureDetector(
                onTap: _messageController != null
                    ? () {
                        // print('chat message: ${messages}');
                        SocketUtilsClient.instance.sendMessage(
                          messageController: _messageController,
                          userId: int.parse(PreferencesHelper.getString(
                              PreferencesHelper.KEY_USER_ID)),
                          userType: PreferencesHelper.getInt(
                                      PreferencesHelper.KEY_USER_TYPE) ==
                                  1
                              ? 'client'
                              : 'candidate',
                          receiverId: receiverId,
                          messageType: 'text',
                        );
                        _messageController.clear();
                      }
                    : null,
                child: Icon(
                  Icons.send_outlined,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

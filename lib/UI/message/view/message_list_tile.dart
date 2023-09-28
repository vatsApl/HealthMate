import 'package:cached_network_image/cached_network_image.dart';
import 'package:clg_project/allAPIs/allAPIs.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';
import '../../../custom_widgets/image_ext.dart';
import '../../../custom_widgets/my_divider.dart';
import '../../../custom_widgets/widget_util.dart';
import '../../../resourse/app_colors.dart';
import '../../../resourse/dimens.dart';
import '../../../resourse/images.dart';
import '../model/candidate_chat_list_model.dart';

class MessageListTile extends BasePageScreen {
  CandidateChatListData? candidateChatListData;
  MessageListTile({required this.candidateChatListData});
  @override
  State<MessageListTile> createState() => _MessageListTileState();
}

class _MessageListTileState extends State<MessageListTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: Dimens.pixel_16,
            right: Dimens.pixel_16,
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    Visibility(
                        // visible: editSelect,
                        child: Row(
                      children: [
                        WidgetUtil.spaceHorizontal(
                          Dimens.pixel_0,
                        ),
                        // InkWell(
                        //   // onTap: tapOnSelection,
                        //
                        //   // child: SvgLoader.load(messageSelection
                        //   //     ? Images.message_select
                        //   //     : Images.message_unselect),
                        //   child: Icon(Icons.done_outline),
                        // ),
                        // WidgetUtil.spaceHorizontal(
                        //   Dimens.pixel_19,
                        // ),
                      ],
                    )),
                    Stack(children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: Dimens.pixel_16, bottom: Dimens.pixel_16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: /*Image.network(
                              gaplessPlayback: true,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: Container(
                                    color: Colors.transparent,
                                    width: 50,
                                    height: 50,
                                    child: SvgLoader.load(Images.profile),
                                  ),
                                );
                              },
                              fit: BoxFit.cover,
                              '$imageUrl' ?? Images.profile,
                              width: 50,
                              height: 50,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child: SizedBox(
                                    width: 50,
                                    height: 50,
                                    child: SvgLoader.load(Images.profile),
                                  ),
                                );
                              },
                            )*/
                              CachedNetworkImage(
                            useOldImageOnUrlChange: true,
                            imageUrl:
                                '${DataURL.baseUrl}/${widget.candidateChatListData?.avatar}',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => ClipRRect(
                              borderRadius: BorderRadius.circular(27),
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: SvgLoader.load(Images.profile),
                                // child: Icon(Icons.person_outline),
                              ),
                            ),
                            errorWidget: (context, url, error) => ClipRRect(
                              borderRadius: BorderRadius.circular(27),
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: SvgLoader.load(Images.profile),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Positioned(
                      //   bottom: 5,
                      //   right: 5,
                      //   child: Container(
                      //       height: 10,
                      //       width: 10,
                      //       decoration: BoxDecoration(
                      //           shape: BoxShape.circle, color: color)),
                      // ),
                    ]),
                    WidgetUtil.spaceHorizontal(
                      Dimens.pixel_12,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  PreferencesHelper.getInt(PreferencesHelper
                                              .KEY_USER_TYPE) ==
                                          2
                                      ? '${widget.candidateChatListData?.practiceName}'
                                      : '${widget.candidateChatListData?.firstName} ${widget.candidateChatListData?.lastName}',
                                  style: medium16TextStyle.copyWith(
                                      color: AppColors.darkGrey),
                                ),
                                // Column(children: [
                                //   DateFormat('dd-MM-yyyy')
                                //       .format(DateTime.now()) !=
                                //       date
                                //       ? Text(date,
                                //       style: isMessageRead != Strings.Zero
                                //           ? Styles.semiBold14TextStyle
                                //           .copyWith(
                                //           fontSize: Dimens.pixel_12,
                                //           color: isMessageRead !=
                                //               Strings.Zero
                                //               ? AppColors.themeColor
                                //               : AppColors.colorGrey)
                                //           : Styles.medium14TextStyle
                                //           .copyWith(
                                //           fontSize: Dimens.pixel_12,
                                //           color: isMessageRead !=
                                //               Strings.Zero
                                //               ? AppColors.themeColor
                                //               : AppColors
                                //               .colorGrey))
                                //       : SizedBox(),
                                //   Text(time.toLowerCase(),
                                //       style: isMessageRead != Strings.Zero
                                //           ? Styles.semiBold14TextStyle.copyWith(
                                //           fontSize: Dimens.pixel_12,
                                //           color:
                                //           isMessageRead != Strings.Zero
                                //               ? AppColors.themeColor
                                //               : AppColors.colorGrey)
                                //           : Styles.medium14TextStyle.copyWith(
                                //           fontSize: Dimens.pixel_12,
                                //           color:
                                //           isMessageRead != Strings.Zero
                                //               ? AppColors.themeColor
                                //               : AppColors.colorGrey)),
                                // ]),
                                Text(
                                  DateFormat('hh:mm a').format(
                                    DateTime.now(),
                                  ),
                                ),
                              ],
                            ),
                            WidgetUtil.spaceVertical(
                              Dimens.pixel_0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Expanded(
                                //   child: isTyping == true
                                //       ? Text(messageText,
                                //       maxLines: 1,
                                //       overflow: TextOverflow.ellipsis,
                                //       style: Styles.medium14TextStyle
                                //           .copyWith(
                                //           color: AppColors.themeColor))
                                //       : Row(
                                //     mainAxisAlignment:
                                //     MainAxisAlignment.start,
                                //     children: [
                                //       userStatus != ""
                                //           ? SvgLoader.load(userStatus)
                                //           : SizedBox(),
                                //       WidgetUtil.spaceHorizontal(
                                //         lastMsgFromyou
                                //             ? Dimens.pixel_3
                                //             : 0,
                                //       ),
                                //       Visibility(
                                //           visible: lastMsgFromyou,
                                //           child: Text(Strings.you,
                                //               style: Styles
                                //                   .regular14TextStyle
                                //                   .copyWith(
                                //                   color: AppColors
                                //                       .colorGrey))),
                                //       WidgetUtil.spaceHorizontal(
                                //         lastMsgFromyou
                                //             ? Dimens.pixel_3
                                //             : 0,
                                //       ),
                                //       Visibility(
                                //           visible: isTyping == true
                                //               ? false
                                //               : msgType ==
                                //               MessageType
                                //                   .PDF.name ||
                                //               msgType ==
                                //                   MessageType
                                //                       .Doc.name ||
                                //               msgType == "docx" ||
                                //               msgType == "ppt" ||
                                //               msgType == "pptx" ||
                                //               msgType == "xls" ||
                                //               msgType == "xlsx" ||
                                //               msgType ==
                                //                   MessageType
                                //                       .Image.name,
                                //           child: SvgLoader.load(
                                //             getDocumentIcon(),
                                //           )),
                                //       WidgetUtil.spaceHorizontal(
                                //         isTyping == true
                                //             ? 0
                                //             : msgType ==
                                //             MessageType
                                //                 .PDF.name ||
                                //             msgType ==
                                //                 MessageType
                                //                     .Doc.name ||
                                //             msgType == "docx" ||
                                //             msgType == "ppt" ||
                                //             msgType == "pptx" ||
                                //             msgType == "xls" ||
                                //             msgType == "xlsx" ||
                                //             msgType ==
                                //                 MessageType
                                //                     .Image.name
                                //             ? Dimens.pixel_3
                                //             : 0,
                                //       ),
                                //       Flexible(
                                //         child: Text(messageText,
                                //             maxLines: 1,
                                //             overflow:
                                //             TextOverflow.ellipsis,
                                //             style: Styles
                                //                 .regular14TextStyle
                                //                 .copyWith(
                                //                 color: isTyping ==
                                //                     true
                                //                     ? AppColors
                                //                     .themeColor
                                //                     : AppColors
                                //                     .colorGrey)),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                // (isMessageRead != Strings.Zero)
                                //     ? Container(
                                //   alignment: Alignment.center,
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(
                                //         Dimens.pixel_29),
                                //     color: AppColors.themeColor,
                                //   ),
                                //   height: Dimens.pixel_20,
                                //   width: Dimens.pixel_20,
                                //   child: Text(
                                //     isMessageRead,
                                //     maxLines: 1,
                                //     overflow: TextOverflow.ellipsis,
                                //     textAlign: TextAlign.center,
                                //     style: Styles.regular12TextStyle
                                //         .copyWith(color: AppColors.white),
                                //   ),
                                // )
                                //     : SizedBox(),
                                Text(
                                    '${TimeOfDay.fromDateTime(DateTime.now())}'),
                                Text('data'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.pixel_16),
          child: MyDivider(
            color: AppColors.dividerColor,
            height: Dimens.pixel_1,
          ),
        ),
      ],
    );
  }
}

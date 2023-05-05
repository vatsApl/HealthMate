import 'dart:convert';
import 'dart:developer';
import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:clg_project/UI/widgets/custom_textfield.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/personal_details_res.dart';
import 'package:clg_project/resourse/api_urls.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../allAPIs/allAPIs.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../../custom_widgets/custom_widget_helper.dart';
import '../resourse/app_colors.dart';
import '../resourse/dimens.dart';

class ClientPersonalDetails extends BasePageScreen {
  @override
  State<ClientPersonalDetails> createState() => _ClientPersonalDetailsState();
}

class _ClientPersonalDetailsState
    extends BasePageScreenState<ClientPersonalDetails> with BaseScreen {
  bool isVisible = false;
  File? imageFile;
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  String? netImg;

  Future getImageFromGallary() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        actionUpdateProfile();
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        actionUpdateProfile();
      });
    } else {
      debugPrint('No image selected.');
    }
  }

  String genderValue = 'M';
  TextEditingController fnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();

  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  PersonalDetailsResponse? personalDetailsResponse;

  //client personal details api
  Future<void> clientPersonalDetailsApi() async {
    String url = ApiUrl.clientPersonalDetailsApi(uId);
    try {
      setState(() {
        isVisible = true;
      });
      var response = await http.get(Uri.parse(url));
      log('client p details: ${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        personalDetailsResponse = PersonalDetailsResponse.fromJson(json);
        fnameController.text =
            personalDetailsResponse?.data?.practiceName ?? '';
        phoneController.text = personalDetailsResponse?.data?.phone ?? '';
        emailController.text = personalDetailsResponse?.data?.email ?? '';
        netImg = personalDetailsResponse?.data?.avatar.toString();
        setState(() {
          isVisible = false;
          PreferencesHelper.setString(
              PreferencesHelper.KEY_CLIENT_AVATAR, netImg!);
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isVisible = false;
      });
    }
    setState(() {
      isVisible = false;
    });
  }

  void updateClientDetails() async {
    var url = (ApiUrl.clientPersonalDetailsUpdateApi);
    var response = await http.post(Uri.parse(url), body: {
      'id': uId,
      'practice_name': fnameController.text,
      'phone': phoneController.text,
    });
    if (response.statusCode == 200) {
      print('data updated successfully');
      setState(() {
        PreferencesHelper.setString(
            PreferencesHelper.KEY_CLIENT_NAME, fnameController.text);
      });
      var json = jsonDecode(response.body);
      Fluttertoast.showToast(
        msg: "${json['message']}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: json['code'] == 200 ? Colors.green : Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
    } else {
      debugPrint('failed');
      debugPrint(response.statusCode as String?);
    }
  }

  actionUpdateProfile() {
    uploadFileToServerApi(imageFile);
  }

  void uploadFileToServerApi(File? imagePath) async {
    String url = ApiUrl.clientUploadFileToServerApi;
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.fields['id'] = uId;
    var stream = http.ByteStream(
        DelegatingStream.typed(imageFile?.openRead() as Stream));
    // get file length
    var fileExtension = imageFile?.path.split('.').last;
    var length = await imageFile?.length();
    request.files.add(http.MultipartFile(
      'avatar', stream, length!, filename: "${DateTime.now()}.$fileExtension",
      // contentType:  MediaType('image', 'jpg')
    ));
    request.send().then((response) {
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Profile photo uploaded",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      PreferencesHelper.setString(
          PreferencesHelper.KEY_CLIENT_AVATAR, netImg ?? '');
      http.Response.fromStream(response).then((onValue) {
        try {
          clientPersonalDetailsApi();
          print('success');
          print(response);
        } catch (e) {
          print('failed');
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    isSaveButton(true);
    clientPersonalDetailsApi();
  }

  @override
  void onClickSaveButton() {
    updateClientDetails();
    actionUpdateProfile();
  }

  @override
  Widget body() {
    return isVisible
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Dimens.pixel_16,
                  Dimens.pixel_0,
                  Dimens.pixel_16,
                  Dimens.pixel_16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: Dimens.pixel_23,
                    ),
                    TitleText(title: Strings.text_personal_details),
                    const SizedBox(
                      height: Dimens.pixel_48,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          SizedBox(
                            height: Dimens.pixel_100,
                            width: Dimens.pixel_100,
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.kDefaultPurpleColor,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: '${DataURL.baseUrl}/$netImg',
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) => CircleAvatar(
                                  child: SvgPicture.asset(
                                    Images.ic_person,
                                    color: Colors.white,
                                    height: Dimens.pixel_50,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  child: SvgPicture.asset(
                                    Images.ic_person,
                                    color: Colors.white,
                                    height: Dimens.pixel_50,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: Dimens.pixel_0,
                            bottom: Dimens.pixel_0,
                            child: SizedBox(
                              height: Dimens.pixel_30,
                              width: Dimens.pixel_30,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                      Dimens.pixel_50,
                                    ),
                                  ),
                                  border: Border.all(
                                    color: AppColors.kDefaultPurpleColor,
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    // show bottom sheet for select picture
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(
                                            Dimens.pixel_6,
                                          ),
                                        ),
                                      ),
                                      builder: (context) =>
                                          SingleChildScrollView(
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: Dimens.pixel_1,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                leading: SvgPicture.asset(
                                                  Images.ic_documents_select,
                                                ),
                                                title: const Text(
                                                  Strings.text_documents,
                                                  style: kSelectDocsTextStyle,
                                                ),
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  getImageFromCamera();
                                                  Navigator.of(context).pop();
                                                },
                                                leading: SvgPicture.asset(
                                                  Images.ic_camera_select,
                                                ),
                                                title: const Text(
                                                  Strings.text_camera,
                                                  style: kSelectDocsTextStyle,
                                                ),
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  getImageFromGallary();
                                                  Navigator.of(context).pop();
                                                },
                                                leading: SvgPicture.asset(
                                                  Images.ic_photos_select,
                                                ),
                                                title: const Text(
                                                    Strings.text_photos,
                                                    style:
                                                        kSelectDocsTextStyle),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: imageFile == null
                                        ? Colors.white
                                        : AppColors.kDefaultPurpleColor,
                                    child: SvgPicture.asset(
                                      Images.ic_camera,
                                      color: imageFile == null
                                          ? AppColors.kDefaultPurpleColor
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_50,
                    ),
                    const Text(
                      Strings.personal_details_label_first_name,
                      style: kTextFormFieldLabelStyle,
                    ),
                    CustomTextFormField(
                      hint: Strings.personal_details_hint_first_name,
                      // validator: Validate.validateName,
                      svgPrefixIcon: SvgPicture.asset(
                        Images.ic_person,
                        fit: BoxFit.scaleDown,
                      ),
                      controller: fnameController,
                    ),
                    const SizedBox(
                      height: Dimens.pixel_26,
                    ),
                    const Text(
                      Strings.label_email,
                      style: kTextFormFieldLabelStyle,
                    ),
                    CustomTextFormField(
                      hint: Strings.hint_email,
                      controller: emailController,
                      readOnly: true,
                      inputType: TextInputType.emailAddress,
                      svgPrefixIcon: SvgPicture.asset(
                        Images.ic_mail,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_26,
                    ),
                    const Text(
                      Strings.label_phone_number,
                      style: kTextFormFieldLabelStyle,
                    ),
                    CustomTextFormField(
                      hint: Strings.hint_phone_number,
                      controller: phoneController,
                      inputType: TextInputType.number,
                      svgPrefixIcon: SvgPicture.asset(
                        Images.ic_call,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                    const SizedBox(
                      height: Dimens.pixel_26,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

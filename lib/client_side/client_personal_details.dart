import 'dart:convert';
import 'dart:developer';
import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:clg_project/UI/widgets/custom_textfield.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/personal_details_res.dart';
import 'package:clg_project/resourse/api_urls.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../../allAPIs/allAPIs.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import '../../custom_widgets/custom_widget_helper.dart';

class ClientPersonalDetails extends StatefulWidget {
  const ClientPersonalDetails({Key? key}) : super(key: key);

  @override
  State<ClientPersonalDetails> createState() => _ClientPersonalDetailsState();
}

class _ClientPersonalDetailsState extends State<ClientPersonalDetails> {
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
        print('No image selected.');
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
        print('No image selected.');
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
  Future<void> clientPersonalDetails() async {
    String url = '${DataURL.baseUrl}/api/client/$uId/index';
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
          PreferencesHelper.setString(PreferencesHelper.KEY_CLIENT_AVATAR, netImg!);
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
    var url = (ApiUrl.clientPersonalDetailsUpdate);
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
    uploadFileToServer(imageFile);
  }

  void uploadFileToServer(File? imagePath) async {
    var url = ('${DataURL.baseUrl}/api/client/upload/image');
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
      if(response.statusCode == 200){
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
      PreferencesHelper.setString(PreferencesHelper.KEY_CLIENT_AVATAR, netImg ?? '');
      http.Response.fromStream(response).then((onValue) {
        try {
          clientPersonalDetails();
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
    clientPersonalDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomWidgetHelper.appBar(
        context: context,
        onActionTap: () {
          updateClientDetails();
          actionUpdateProfile();
        },
        action: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SvgPicture.asset(
            Images.ic_true,
            height: 28.0,
          ),
        ),
      ),
      body: isVisible
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 23.0,
                      ),
                      TitleText(title: 'Personal Details'),
                      const SizedBox(
                        height: 48.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 100.0,
                              width: 100.0,
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kDefaultPurpleColor,
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
                                      height: 50.0,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    child: SvgPicture.asset(
                                      Images.ic_person,
                                      color: Colors.white,
                                      height: 50.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0.0,
                              bottom: 0.0,
                              child: SizedBox(
                                height: 30.0,
                                width: 30.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                    border: Border.all(
                                      color: kDefaultPurpleColor,
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
                                            top: Radius.circular(6.0),
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
                                                width: 1.0,
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
                                                    'Documents',
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
                                                  title: const Text('Camera',
                                                      style:
                                                          kSelectDocsTextStyle),
                                                ),
                                                ListTile(
                                                  onTap: () {
                                                    getImageFromGallary();
                                                    Navigator.of(context).pop();
                                                  },
                                                  leading: SvgPicture.asset(
                                                    Images.ic_photos_select,
                                                  ),
                                                  title: const Text('Photos',
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
                                          : kDefaultPurpleColor,
                                      child: SvgPicture.asset(
                                        Images.ic_camera,
                                        color: imageFile == null
                                            ? kDefaultPurpleColor
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
                        height: 50.0,
                      ),
                      const Text(
                        'First Name',
                        style: kTextFormFieldLabelStyle,
                      ),
                      CustomTextFormField(
                        hint: 'First Name',
                        // validator: Validate.validateName,
                        svgPrefixIcon: SvgPicture.asset(
                          Images.ic_person,
                          fit: BoxFit.scaleDown,
                        ),
                        controller: fnameController,
                      ),
                      const SizedBox(
                        height: 26.0,
                      ),
                      const Text(
                        'Email',
                        style: kTextFormFieldLabelStyle,
                      ),
                      CustomTextFormField(
                        hint: 'Enter Email Address',
                        controller: emailController,
                        readOnly: true,
                        inputType: TextInputType.emailAddress,
                        svgPrefixIcon: SvgPicture.asset(
                          Images.ic_mail,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      const SizedBox(
                        height: 26.0,
                      ),
                      const Text(
                        'Phone Number',
                        style: kTextFormFieldLabelStyle,
                      ),
                      CustomTextFormField(
                        hint: 'Enter Phone Number',
                        controller: phoneController,
                        inputType: TextInputType.number,
                        svgPrefixIcon: SvgPicture.asset(
                          Images.ic_call,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      const SizedBox(
                        height: 26.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

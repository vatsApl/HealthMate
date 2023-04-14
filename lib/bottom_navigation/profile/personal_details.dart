import 'dart:convert';
import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:clg_project/UI/widgets/custom_textfield.dart';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/models/personal_details_res.dart';
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

class PersonalDetails extends StatefulWidget {
  const PersonalDetails({Key? key}) : super(key: key);

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
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
    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        actionUpdateProfile();
      } else {
        print('No image selected.');
      }
    });
  }

  // var uFirstName = PreferencesHelper.getString(PreferencesHelper.KEY_FIRST_NAME);
  // var uLastName = PreferencesHelper.getString(PreferencesHelper.KEY_LAST_NAME);
  // var uEmail = PreferencesHelper.getString(PreferencesHelper.KEY_EMAIL);
  // var uPhone = PreferencesHelper.getString(PreferencesHelper.KEY_PHONE);
  String genderValue = 'M';
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  bool isShowPass = true;
  bool isShowCpass = true;
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  PersonalDetailsResponse? personalDetailsResponse;

  //personal details api
  Future<void> personalDetails() async {
    String url = '${DataURL.baseUrl}/api/candidate/$uId/index';
    try {
      var response = await http.get(Uri.parse(url));
      print('personal details: ${response.body}');
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        personalDetailsResponse = PersonalDetailsResponse.fromJson(json);
        fnameController.text =
            personalDetailsResponse?.data?.firstName.toString() ?? '';
        lnameController.text =
            personalDetailsResponse?.data?.lastName.toString() ?? '';
        genderValue = personalDetailsResponse?.data?.gender.toString() ?? '';
        emailController.text =
            personalDetailsResponse?.data?.email.toString() ?? '';
        phoneController.text =
            personalDetailsResponse?.data?.phone.toString() ?? '';
        // imageFile = personalDetailsResponse?.data?.avatar as File?;
        netImg = personalDetailsResponse?.data?.avatar.toString();
        PreferencesHelper.setString(PreferencesHelper.KEY_AVATAR, netImg!);
        setState(() {
          isVisible = true;
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

  // Future<void> personalDetailsUpdateData(File imageFile) async {
  //   var url = ('${DataURL.baseUrl}/api/candidate/editprofile');
  //   var imagename = path.basename(imageFile.path);
  //   print('needed : $imagename');
  //   try {
  //     setState(() {
  //       isVisible = true;
  //     });
  //     String fileName = imageFile!.path.split('/').last;
  //     var request = await http.MultipartRequest('POST', Uri.parse(url));
  //     var extension = path.extension(imageFile!.path);
  //     request.files.add(await http.MultipartFile.fromPath(imageFile.toString(), imageFile!.path, filename: imagename));
  //     var responseTwo = await request.send();
  //     if(responseTwo.statusCode == 200){
  //       print('File uploaded successfully');
  //     } else {
  //       print('failed');
  //     }
  //
  //     var response = await http.post(Uri.parse(url), body: {
  //       'id': uId,
  //       'avatar': imageFile.toString(),
  //       'first_name': fnameController.text,
  //       'last_name': lnameController.text,
  //       'gender': genderValue,
  //       'email': emailController.text,
  //       'phone': phoneController.text,
  //     });
  //     print(response.body);
  //     if (response.statusCode == 200) {
  //       var json = jsonDecode(response.body);
  //       Fluttertoast.showToast(
  //         msg: "${json['message']}",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: json['code'] == 200 ? Colors.green : Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0,
  //       );
  //       if(json['code'] == 200){
  //         Navigator.pop(context);
  //       }
  //       // var json = jsonDecode(response.body);
  //       // personalDetailsResponse = PersonalDetailsResponse.fromJson(json);
  //       // fnameController.text =
  //       //     personalDetailsResponse?.data?.firstName.toString() ?? '';
  //       // lnameController.text =
  //       //     personalDetailsResponse?.data?.lastName.toString() ?? '';
  //       // genderValue = personalDetailsResponse?.data?.gender.toString() ?? '';
  //       // emailController.text =
  //       //     personalDetailsResponse?.data?.email.toString() ?? '';
  //       // phoneController.text =
  //       //     personalDetailsResponse?.data?.phone.toString() ?? '';
  //       // imageFile = personalDetailsResponse?.data?.avatar;
  //       // PreferencesHelper.setString(
  //       //     PreferencesHelper.KEY_AVATAR, imageFile as String);
  //       // if (json['code'] == 200) {
  //       //   setState(() {
  //       //     isVisible = false;
  //       //   });
  //       //   //navigate to home screen after verified according to the type Client or candidate:
  //       // }
  //     }
  //   } catch (e) {
  //     print(e);
  //     setState(() {
  //       isVisible = false;
  //     });
  //   }
  //   setState(() {
  //     isVisible = false;
  //   });
  // }
  @override
  void initState() {
    super.initState();
    personalDetails();
    // print('this is: $netImg');
  }

  void updateDetails() async {
    var url = ('${DataURL.baseUrl}/api/candidate/editprofile');
    var response = await http.post(Uri.parse(url), body: {
      'id': uId,
      'first_name': fnameController.text,
      'last_name': lnameController.text,
      'gender': genderValue,
      'email': emailController.text,
      'phone': phoneController.text,
    });
    if (response.statusCode == 200) {
      print('data updated successfully');
      setState(() {
        PreferencesHelper.setString(PreferencesHelper.KEY_FIRST_NAME, fnameController.text);
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
      print('failed');
      print(response.statusCode);
    }
  }

  actionUpdateProfile() {
    uploadFileToServer(imageFile);
  }

  void uploadFileToServer(File? imagePath) async {
    var url = ('${DataURL.baseUrl}/api/candidate/upload/image');
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.fields['id'] = uId;
    // request.fields['first_name'] = fnameController.text;
    // request.fields['last_name'] = lnameController.text;
    // request.fields['gender'] = genderValue;
    // request.fields['email'] = emailController.text;
    // request.fields['phone'] = phoneController.text;
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
      http.Response.fromStream(response).then((onValue) {
        try {
          personalDetails();
          print('success');
          print(response);
          // Fluttertoast.showToast(
          //   msg: "${response['message']}",
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.BOTTOM,
          //   timeInSecForIosWeb: 1,
          //   backgroundColor: json['code'] == 200 ? Colors.green : Colors.red,
          //   textColor: Colors.white,
          //   fontSize: 16.0,
          // );
        } catch (e) {
          print('failed');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomWidgetHelper.appBar(
        context: context,
        onActionTap: (){
          updateDetails();
        },
        action: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SvgPicture.asset(
            Images.ic_true,
            height: 28.0,
          ),
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     InkWell(
                    //       onTap: () {
                    //         Navigator.pop(context);
                    //       },
                    //       child: SvgPicture.asset(
                    //         Images.ic_left_arrow,
                    //         fit: BoxFit.scaleDown,
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       onTap: () async {
                    //         // actionUpdateProfile();
                    //         updateDetails();
                    //         // Navigator.pop(context);
                    //       },
                    //       child: SvgPicture.asset(
                    //         Images.ic_true,
                    //         height: 28.0,
                    //         // fit: BoxFit.scaleDown,
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
                                          // height: 147.0,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                              width: 1.0,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                onTap: (){
                                                  Navigator.of(context).pop();
                                                },
                                                leading: SvgPicture.asset(
                                                    Images.ic_documents_select,
                                                ),
                                                title: const Text('Documents', style: kSelectDocsTextStyle),
                                              ),
                                              ListTile(
                                                onTap: (){
                                                  getImageFromCamera();
                                                  Navigator.of(context).pop();
                                                },
                                                leading: SvgPicture.asset(
                                                  Images.ic_camera_select,
                                                ),
                                                title: const Text('Camera', style: kSelectDocsTextStyle),
                                              ),
                                              ListTile(
                                                onTap: (){
                                                  getImageFromGallary();
                                                  Navigator.of(context).pop();
                                                },
                                                leading: SvgPicture.asset(
                                                  Images.ic_photos_select,
                                                ),
                                                title: const Text('Photos', style: kSelectDocsTextStyle),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                    // setState(() {
                                    //   // getImageFromCamera();
                                    //   // getImageFromGallary();
                                    // });
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
                      'Last Name',
                      style: kTextFormFieldLabelStyle,
                    ),
                    CustomTextFormField(
                      hint: 'Last Name',
                      svgPrefixIcon: SvgPicture.asset(
                        Images.ic_person,
                        fit: BoxFit.scaleDown,
                      ),
                      controller: lnameController,
                    ),
                    const SizedBox(
                      height: 26.0,
                    ),
                    Text(
                      'Gender',
                      style: kTextFormFieldLabelStyle.copyWith(
                          fontSize: 14.0, color: kDefaultBlackColor),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 'M',
                          groupValue: genderValue,
                          onChanged: (String? value) {
                            setState(() {
                              genderValue = value!;
                            });
                          },
                        ),
                        const Text(
                          'Male',
                          style: TextStyle(
                            color: klabelColor,
                          ),
                        ),
                        Radio(
                          value: 'F',
                          groupValue: genderValue,
                          onChanged: (String? value) {
                            setState(() {
                              genderValue = value!;
                            });
                          },
                        ),
                        const Text(
                          'Female',
                          style: TextStyle(color: klabelColor),
                        ),
                        Radio(
                          value: 'O',
                          groupValue: genderValue,
                          onChanged: (String? value) {
                            setState(() {
                              genderValue = value!;
                            });
                          },
                        ),
                        const Text(
                          'Others',
                          style: TextStyle(color: klabelColor),
                        ),
                      ],
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
                    const Text(
                      'Password',
                      style: kTextFormFieldLabelStyle,
                    ),
                    CustomTextFormField(
                      hint: 'Enter Password',
                      controller: passController,
                      obscureText: isShowPass ? true : false,
                      maxLines: 1,
                      svgPrefixIcon: SvgPicture.asset(
                        Images.ic_password,
                        fit: BoxFit.scaleDown,
                      ),
                      suffixIcon:
                          isShowPass ? Images.ic_eye : Images.ic_eye_off,
                      obscureTap: () {
                        setState(() {
                          isShowPass = !isShowPass;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 26.0,
                    ),
                    const Text(
                      'Confirm Password',
                      style: kTextFormFieldLabelStyle,
                    ),
                    CustomTextFormField(
                      hint: 'Enter Confirm Password',
                      controller: confirmPassController,
                      obscureText: true,
                      maxLines: 1, //obscure text can not be multiline
                      svgPrefixIcon: SvgPicture.asset(
                        Images.ic_password,
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
            visible: isVisible,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
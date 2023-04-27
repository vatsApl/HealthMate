import 'dart:io';
import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/constants.dart';
import 'package:clg_project/resourse/api_urls.dart';
import 'package:clg_project/resourse/images.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../custom_widgets/custom_widget_helper.dart';
import 'package:http/http.dart' as http;
import '../../resourse/dimens.dart';
import '../../resourse/shared_prefs.dart';

class CvResume extends BasePageScreen {
  @override
  State<CvResume> createState() => _CvResumeState();
}

class _CvResumeState extends BasePageScreenState<CvResume> with BaseScreen {
  String? fileName;
  String filePath = '';
  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  getData() {
    filePath = PreferencesHelper.getString(PreferencesHelper.KEY_CV);
  }

  //upload file to server:
  Future<void> _uploadCv(String? filePathOfCv) async {
    var request = http.MultipartRequest('POST', Uri.parse(ApiUrl.uploadCv));
    request.fields.addAll({'id': uId});
    request.files.add(await http.MultipartFile.fromPath(
        'cv', filePathOfCv ?? '')); // file you want to upload
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      PreferencesHelper.setString(PreferencesHelper.KEY_CV, filePath);
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: "CV uploaded successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      debugPrint('uploaded');
    } else {
      debugPrint(response.reasonPhrase);
      debugPrint('not uploaded');
    }
  }

  //select file from device
  void pickFile() async {
    FilePickerResult? resultFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'xls', 'xlx'],
    );
    if (resultFile != null) {
      PlatformFile file = resultFile.files.first;
      debugPrint('filename:${file.name}');
      setState(() {
        fileName = file.name;
        filePath = file.path ?? '';
      });
      debugPrint('bytes:${file.bytes}');
      debugPrint('extension:${file.extension}');
      debugPrint('path:${file.path}');
    } else {
      debugPrint('no file selected');
    }
  }

  @override
  void initState() {
    super.initState();
    isSaveButton(true);
    getData();
  }

  @override
  void onClickSaveButton() {
    _uploadCv(filePath);
  }
  @override
  Widget body() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Dimens.pixel_16, Dimens.pixel_0, Dimens.pixel_16, Dimens.pixel_16,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: Dimens.pixel_23,
            ),
            TitleText(title: Strings.text_title_cv_and_resume,),
            const SizedBox(
              height: Dimens.pixel_48,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  Strings.text_selected_file,
                  style: TextStyle(
                    fontSize: Dimens.pixel_16,
                    fontWeight: FontWeight.w400,
                    color: kDefaultBlackColor,
                  ),
                ),
                const SizedBox(
                  height: Dimens.pixel_10,
                ),
                Text(fileName ?? ''),
                const SizedBox(
                  height: Dimens.pixel_10,
                ),
                SizedBox(
                  width: Dimens.pixel_334,
                  height: Dimens.pixel_471,
                  child: filePath != '' && filePath.contains('.jpg')
                      ? Image.file(
                    File(filePath),
                    fit: BoxFit.cover,
                  )
                      : filePath != '' && filePath.contains('.pdf')
                      ? PDFView(
                    filePath: filePath,
                    fitEachPage: true,
                  )
                      : Container(),
                ),
                const SizedBox(
                  height: Dimens.pixel_30,
                ),
                SizedBox(
                  width: double.infinity,
                  height: Dimens.pixel_44,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimens.pixel_6,),
                          side: const BorderSide(color: kDefaultPurpleColor),
                      ),
                    ),
                    onPressed: () async {
                      pickFile();
                    },
                    child: const Text(
                      Strings.text_add_new_resume,
                      style: TextStyle(
                          fontSize: Dimens.pixel_16,
                          color: kDefaultPurpleColor,
                          fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
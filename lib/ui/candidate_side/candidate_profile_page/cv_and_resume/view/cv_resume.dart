import 'dart:io';

import 'package:clg_project/UI/widgets/title_text.dart';
import 'package:clg_project/base_Screen_working/base_screen.dart';
import 'package:clg_project/custom_widgets/custom_widget_helper.dart';
import 'package:clg_project/resourse/strings.dart';
import 'package:clg_project/ui/candidate_side/candidate_profile_page/cv_and_resume/bloc/cv_resume_bloc.dart';
import 'package:clg_project/ui/candidate_side/candidate_profile_page/cv_and_resume/bloc/cv_resume_state.dart';
import 'package:clg_project/ui/client_side/client_home_page/client_job_description/model/basic_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../MyFirebaseService.dart';
import '../../../../../resourse/app_colors.dart';
import '../../../../../resourse/dimens.dart';
import '../../../../../resourse/shared_prefs.dart';
import '../bloc/cv_resume_event.dart';
import '../repo/cv_resume_repository.dart';

class CvResume extends BasePageScreen {
  @override
  State<CvResume> createState() => _CvResumeState();
}

class _CvResumeState extends BasePageScreenState<CvResume> with BaseScreen {
  String? fileName;
  String filePath = '';
  bool isVisible = false;

  var uId = PreferencesHelper.getString(PreferencesHelper.KEY_USER_ID);
  getData() {
    filePath = PreferencesHelper.getString(PreferencesHelper.KEY_CV);
  }

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

  getAnalytics() async {
    // google analytics
    await MyFirebaseService.logScreen('candidate cv-resume screen');
  }

  @override
  void initState() {
    super.initState();
    isSaveButton(true);
    getData();
    getAnalytics();
  }

  @override
  void onClickSaveButton() {
    /// event of upload cv
    _cvResumeBloc.add(UploadCvEvent(filePathOfCv: filePath));
  }

  final _cvResumeBloc = CvResumeBloc(CvResumeRepository());

  @override
  void dispose() {
    _cvResumeBloc.close();
    super.dispose();
  }

  @override
  Widget body() {
    return BlocProvider<CvResumeBloc>(
      create: (BuildContext context) => _cvResumeBloc,
      child: BlocListener<CvResumeBloc, CvResumeState>(
        listener: (BuildContext context, state) {
          if (state is UploadCvLoadingState) {
            isVisible = true;
          }
          if (state is UploadCvLoadedState) {
            isVisible = false;
            var responseBody = state.response;
            //     print(await response.stream.bytesToString());
            var basicModel = BasicModel.fromJson(responseBody);
            if (basicModel.code == 200) {
              PreferencesHelper.setString(PreferencesHelper.KEY_CV, filePath);
              Navigator.pop(context);
              Fluttertoast.showToast(
                msg: "${basicModel.message}",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              debugPrint('uploaded');
            }
          }
          if (state is UploadCvErrorState) {
            debugPrint(state.error);
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
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
                    TitleText(
                      title: Strings.text_title_cv_and_resume,
                    ),
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
                            color: AppColors.kDefaultBlackColor,
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
                                borderRadius: BorderRadius.circular(
                                  Dimens.pixel_6,
                                ),
                                side: const BorderSide(
                                  color: AppColors.kDefaultPurpleColor,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              pickFile();
                            },
                            child: const Text(
                              Strings.text_add_new_resume,
                              style: TextStyle(
                                fontSize: Dimens.pixel_16,
                                color: AppColors.kDefaultPurpleColor,
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
            ),
            Visibility(
              visible: isVisible,
              child: CustomWidgetHelper.Loader(context: context),
            )
          ],
        ),
      ),
    );
  }

  @override
  update(Observable observable, String? notifyName, Map? map) {
    // TODO: implement update
    throw UnimplementedError();
  }
}

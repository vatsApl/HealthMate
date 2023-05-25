abstract class CvResumeState {}

class UploadCvInitialState extends CvResumeState {}

class UploadCvLoadingState extends CvResumeState {}

class UploadCvLoadedState extends CvResumeState {
  dynamic response;
  UploadCvLoadedState(this.response);
}

class UploadCvErrorState extends CvResumeState {
  final String error;
  UploadCvErrorState({required this.error});
}

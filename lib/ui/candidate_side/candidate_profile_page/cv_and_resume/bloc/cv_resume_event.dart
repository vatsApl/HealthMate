abstract class CvResumeEvent {}

class UploadCvEvent extends CvResumeEvent {
  String filePathOfCv;
  UploadCvEvent({required this.filePathOfCv});
}

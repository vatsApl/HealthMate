import 'dart:io';

abstract class CandidatePersonalDetailsEvent {}

class ShowCandidatePersonalDetailsEvent extends CandidatePersonalDetailsEvent {}

class UpdateCandidateDetails extends CandidatePersonalDetailsEvent {
  Map<String, dynamic> params;
  UpdateCandidateDetails({required this.params});
}

class CandidateUploadProfile extends CandidatePersonalDetailsEvent {
  File? imageFile;
  CandidateUploadProfile({this.imageFile});
}

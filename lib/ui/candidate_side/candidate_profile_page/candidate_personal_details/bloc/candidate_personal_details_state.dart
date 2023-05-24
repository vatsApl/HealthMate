abstract class CandidatePersonalDetailsState {}

class ShowCandidatePersonalDetailsInitialState
    extends CandidatePersonalDetailsState {}

class ShowCandidatePersonalDetailsLoadingState
    extends CandidatePersonalDetailsState {}

class ShowCandidatePersonalDetailsLoadedState
    extends CandidatePersonalDetailsState {
  dynamic response;
  ShowCandidatePersonalDetailsLoadedState(this.response);
}

class ShowCandidatePersonalDetailsErrorState
    extends CandidatePersonalDetailsState {
  final String error;
  ShowCandidatePersonalDetailsErrorState({required this.error});
}

class UpdateCandidateDetailsLoadingState
    extends CandidatePersonalDetailsState {}

class UpdateCandidateDetailsLoadedState extends CandidatePersonalDetailsState {
  dynamic response;
  UpdateCandidateDetailsLoadedState(this.response);
}

class UpdateCandidateDetailsErrorState extends CandidatePersonalDetailsState {
  final String error;
  UpdateCandidateDetailsErrorState({required this.error});
}

class CandidateUploadProfileLoadingState
    extends CandidatePersonalDetailsState {}

class CandidateUploadProfileLoadedState extends CandidatePersonalDetailsState {
  dynamic response;
  CandidateUploadProfileLoadedState(this.response);
}

class CandidateUploadProfileErrorState extends CandidatePersonalDetailsState {
  final String error;
  CandidateUploadProfileErrorState({required this.error});
}

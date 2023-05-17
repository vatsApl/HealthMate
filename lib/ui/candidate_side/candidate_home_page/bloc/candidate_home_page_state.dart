abstract class CandidateHomePageState {}

class CandidateHomePageInitialState extends CandidateHomePageState {}

class CandidateHomePageLoadingState extends CandidateHomePageState {}

class CandidateHomePageLoadedState extends CandidateHomePageState {
  dynamic response;
  CandidateHomePageLoadedState(this.response);
}

class CandidateHomePageErrorState extends CandidateHomePageState {
  final String error;
  CandidateHomePageErrorState({required this.error});
}

abstract class AppliedJobState {}

class ShowAppliedJobInitialState extends AppliedJobState {}

class ShowAppliedJobLoadingState extends AppliedJobState {}

class ShowAppliedJobLoadedState extends AppliedJobState {
  dynamic response;
  ShowAppliedJobLoadedState(this.response);
}

class ShowApliedJobErrorState extends AppliedJobState {
  final String error;
  ShowApliedJobErrorState({required this.error});
}

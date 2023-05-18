abstract class JobDescState {}

class JobDescInitialState extends JobDescState {}

class JobDescLoadingState extends JobDescState {}

class JobDescLoadedState extends JobDescState {
  dynamic response;
  JobDescLoadedState(this.response);
}

class JobDescErrorState extends JobDescState {
  final String error;
  JobDescErrorState({required this.error});
}

class ApplyJobLoadingState extends JobDescState {}

class ApplyJobLoadedState extends JobDescState {
  dynamic response;
  ApplyJobLoadedState(this.response);
}

class ApplyJobErrorState extends JobDescState {
  final String error;
  ApplyJobErrorState({required this.error});
}

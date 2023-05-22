abstract class BookedJobState {}

class ShowBookedJobInitialState extends BookedJobState {}

class ShowBookedJobLoadingState extends BookedJobState {}

class ShowBookedJobLoadedState extends BookedJobState {
  dynamic response;
  ShowBookedJobLoadedState(this.response);
}

class ShowBookedJobErrorState extends BookedJobState {
  final String error;
  ShowBookedJobErrorState({required this.error});
}

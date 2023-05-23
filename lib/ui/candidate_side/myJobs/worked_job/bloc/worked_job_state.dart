abstract class WorkedJobState {}

class ShowWorkedJobInitialState extends WorkedJobState {}

class ShowWorkedJobLoadingState extends WorkedJobState {}

class ShowWorkedJobLoadedState extends WorkedJobState {
  dynamic response;
  ShowWorkedJobLoadedState(this.response);
}

class ShowWorkedJobErrorState extends WorkedJobState {
  final String error;
  ShowWorkedJobErrorState({required this.error});
}

class ShowAmountStatusLoading extends WorkedJobState {}

class ShowAmountStatusLoadedState extends WorkedJobState {
  dynamic response;
  ShowAmountStatusLoadedState(this.response);
}

class ShowAmountStatusErrorState extends WorkedJobState {
  final String error;
  ShowAmountStatusErrorState({required this.error});
}

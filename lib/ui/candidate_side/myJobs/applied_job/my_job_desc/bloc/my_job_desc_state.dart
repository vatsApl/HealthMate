abstract class MyJobDescState {}

class ShowMyJobDescInitialState extends MyJobDescState {}

class ShowMyJobDescLoadingState extends MyJobDescState {}

class ShowMyJobDescLoadedState extends MyJobDescState {
  dynamic response;
  ShowMyJobDescLoadedState(this.response);
}

class ShowMyJobDescErrorState extends MyJobDescState {
  final String error;
  ShowMyJobDescErrorState({required this.error});
}

class WithdrawJobLoadingState extends MyJobDescState {}

class WithdrawJobLoadedState extends MyJobDescState {
  dynamic response;
  WithdrawJobLoadedState(this.response);
}

class WithdrawJobErrorState extends MyJobDescState {
  final String error;
  WithdrawJobErrorState({required this.error});
}

class EditTimesheetLoadingState extends MyJobDescState {}

class EditTimesheetLoadedState extends MyJobDescState {
  dynamic response;
  EditTimesheetLoadedState(this.response);
}

class EditTimesheetErrorState extends MyJobDescState {
  final String error;
  EditTimesheetErrorState({required this.error});
}

abstract class WorkedJobDescState {}

class ShowWorkedJobDescInitialState extends WorkedJobDescState {}

class ShowWorkedJobDescLoadingState extends WorkedJobDescState {}

class ShowWorkedJobDescLoadedState extends WorkedJobDescState {
  dynamic response;
  ShowWorkedJobDescLoadedState(this.response);
}

class ShowWorkedJobDescErrorState extends WorkedJobDescState {
  final String error;
  ShowWorkedJobDescErrorState({required this.error});
}

class EditTimesheetAfterDisputeLoadingState extends WorkedJobDescState {}

class EditTimesheetAfterDisputeLoadedState extends WorkedJobDescState {
  dynamic response;
  EditTimesheetAfterDisputeLoadedState(this.response);
}

class EditTimesheetAfterDisputeErrorState extends WorkedJobDescState {
  final String error;
  EditTimesheetAfterDisputeErrorState({required this.error});
}

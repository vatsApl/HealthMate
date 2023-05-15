abstract class TimesheetDescState {}

class TimesheetDescInitialState extends TimesheetDescState {}

class TimesheetDescLoadingState extends TimesheetDescState {}

class TimesheetDescLoadedState extends TimesheetDescState {
  dynamic response;
  TimesheetDescLoadedState(this.response);
}

class TimesheetDescErrorState extends TimesheetDescState {
  final String error;
  TimesheetDescErrorState({required this.error});
}

class ApproveTimesheetLoadingState extends TimesheetDescState {}

class ApproveTimesheetLoadedState extends TimesheetDescState {
  dynamic response;
  ApproveTimesheetLoadedState(this.response);
}

class ApproveTimesheetErrorState extends TimesheetDescState {
  final String error;
  ApproveTimesheetErrorState({required this.error});
}

abstract class TimesheetState {}

class TimesheetInitialState extends TimesheetState {}

class TimesheetLoadingState extends TimesheetState {}

class TimesheetLoadedState extends TimesheetState {
  dynamic response;
  TimesheetLoadedState(this.response);
}

class TimesheetErrorState extends TimesheetState {
  final String error;
  TimesheetErrorState({required this.error});
}

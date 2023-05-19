abstract class SignOffState {}

class UpdateTimesheetInitialState extends SignOffState {}

class UpdateTimesheetLoadingState extends SignOffState {}

class UpdateTimesheetLoadedState extends SignOffState {
  dynamic response;
  UpdateTimesheetLoadedState(this.response);
}

class UpdateTimesheetErrorState extends SignOffState {
  final String error;
  UpdateTimesheetErrorState({required this.error});
}

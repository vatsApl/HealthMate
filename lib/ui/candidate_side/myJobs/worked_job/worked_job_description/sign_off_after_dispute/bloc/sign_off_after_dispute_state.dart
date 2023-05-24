abstract class SignOffAfterDisputeState {}

class UpdateTimesheetAfterDisputeInitialState
    extends SignOffAfterDisputeState {}

class UpdateTimesheetAfterDisputeLoadingState
    extends SignOffAfterDisputeState {}

class UpdateTimesheetAfterDisputeLoadedState extends SignOffAfterDisputeState {
  dynamic response;
  UpdateTimesheetAfterDisputeLoadedState(this.response);
}

class UpdateTimesheetAfterDisputeErrorState extends SignOffAfterDisputeState {
  final String error;
  UpdateTimesheetAfterDisputeErrorState({required this.error});
}

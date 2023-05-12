abstract class JobApprovalsDescState {}

class ShowJobApprovalsDescInitialState extends JobApprovalsDescState {}

class ShowJobApprovalsDescLoadingState extends JobApprovalsDescState {}

class ShowJobApprovalsDescLoadedState extends JobApprovalsDescState {
  dynamic response;
  ShowJobApprovalsDescLoadedState(this.response);
}

class ShowJobApprovalsDescErrorState extends JobApprovalsDescState {
  final String error;
  ShowJobApprovalsDescErrorState({required this.error});
}

class ApproveApplicationLoadingState extends JobApprovalsDescState {}

class ApproveApplicationLoadedState extends JobApprovalsDescState {
  dynamic response;
  ApproveApplicationLoadedState(this.response);
}

class ApproveApplicationErrorState extends JobApprovalsDescState {
  final String error;
  ApproveApplicationErrorState({required this.error});
}

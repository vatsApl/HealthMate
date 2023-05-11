abstract class ApprovalsState {}

class ApprovalsInitialState extends ApprovalsState {}

class ApprovalsLoadingState extends ApprovalsState {}

class ApprovalsLoadedState extends ApprovalsState {
  dynamic response;
  ApprovalsLoadedState(this.response);
}

class ApprovalsErrorState extends ApprovalsState {
  final String error;
  ApprovalsErrorState({required this.error});
}

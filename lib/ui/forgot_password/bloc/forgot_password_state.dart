abstract class ForgotPasswordState {}

class ForgotPasswordInitialState extends ForgotPasswordState {}

class ForgotPasswordLoadingState extends ForgotPasswordState {}

class ForgotPasswordLoadedState extends ForgotPasswordState {
  dynamic response;
  ForgotPasswordLoadedState(this.response);
}

class ForgotPasswordErrorState extends ForgotPasswordState {
  final String error;
  ForgotPasswordErrorState({required this.error});
}

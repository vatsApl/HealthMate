abstract class ForgotVerificationState {}

class ForgotVerificationInitialState extends ForgotVerificationState {}

class ForgotVerificationLoadingState extends ForgotVerificationState {}

class ForgotVerificationLoadedState extends ForgotVerificationState {
  dynamic response;
  ForgotVerificationLoadedState(this.response);
}

class ForgotVerificationResendLoadedState extends ForgotVerificationState {
  dynamic response;
  ForgotVerificationResendLoadedState(this.response);
}

class ForgotVerificationErrorState extends ForgotVerificationState {
  final String error;
  ForgotVerificationErrorState({required this.error});
}

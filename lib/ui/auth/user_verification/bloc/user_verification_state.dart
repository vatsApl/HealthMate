abstract class UserVerificationState {}

class UserVerificationInitialState extends UserVerificationState {}

class UserVerificationLoadingState extends UserVerificationState {}

class UserVerificationLoadedState extends UserVerificationState {
  dynamic response;
  UserVerificationLoadedState(this.response);
}

class UserVerificationResendOtpLoadedState extends UserVerificationState {
  dynamic response;
  UserVerificationResendOtpLoadedState(this.response);
}

class UserVerificationErrorState extends UserVerificationState {
  final String error;
  UserVerificationErrorState({required this.error});
}

abstract class ForgotVerificationEvent {}

class ForgotVerificationVerifyEvent extends ForgotVerificationEvent {
  Map<String, dynamic> params;
  ForgotVerificationVerifyEvent(this.params);
}

class ForgotVerificationResendEvent extends ForgotVerificationEvent {
  //
}

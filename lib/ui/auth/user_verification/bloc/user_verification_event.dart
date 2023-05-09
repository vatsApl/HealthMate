abstract class UserVerificationEvent {}

class UserVerificationButtonPressed extends UserVerificationEvent {
  Map<String, dynamic> params;
  UserVerificationButtonPressed(this.params);
}

//resend otp event
class UserVerificationResendOtp extends UserVerificationEvent {
  Map<String, dynamic> params;
  UserVerificationResendOtp(this.params);
}

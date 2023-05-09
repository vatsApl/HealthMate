abstract class ForgotPasswordEvent {}

class ForgotPasswordButtonPressed extends ForgotPasswordEvent {
  Map<String, dynamic> params;
  ForgotPasswordButtonPressed(this.params);
}

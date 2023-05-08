abstract class NewPasswordEvent {}

class NewPasswordVerifyButtonPressed extends NewPasswordEvent {
  Map<String, dynamic> params;
  NewPasswordVerifyButtonPressed(this.params);
}

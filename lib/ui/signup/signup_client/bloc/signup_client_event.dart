abstract class SignupClientEvent {}

class SignupClientButtonPressed extends SignupClientEvent {
  Map<String, dynamic> params;
  SignupClientButtonPressed({required this.params});
}

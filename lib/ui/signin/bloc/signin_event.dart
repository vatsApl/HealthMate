abstract class SigninEvent {}

class SigninButtonPressed extends SigninEvent {
  final String email;
  final String password;

  SigninButtonPressed({
    required this.email,
    required this.password,
  });

  // @override
  // List<Object> get props => [email, password];
}

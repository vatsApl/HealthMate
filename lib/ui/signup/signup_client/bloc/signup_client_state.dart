abstract class SignupClientState {}

class SignupClientInitialState extends SignupClientState {}

class SignupClientLoadingState extends SignupClientState {}

class SignupClientLoadedState extends SignupClientState {
  dynamic response;
  SignupClientLoadedState(this.response);
}

class SignupClientErrorState extends SignupClientState {
  final String error;
  SignupClientErrorState({required this.error});
}

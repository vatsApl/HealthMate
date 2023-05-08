abstract class NewPasswordState {}

class NewPasswordInitialState extends NewPasswordState {}

class NewPasswordLoadingState extends NewPasswordState {}

class NewPasswordLoadedState extends NewPasswordState {
  dynamic response;
  NewPasswordLoadedState(this.response);
}

class NewPasswordErrorState extends NewPasswordState {
  final String error;
  NewPasswordErrorState({required this.error});
}

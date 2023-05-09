import '../model/signin_model.dart';

abstract class SigninState {}

class SigninInitialState extends SigninState {}

class SigninLoadingState extends SigninState {}

class SigninLoadedState extends SigninState {
  dynamic response;
  SigninLoadedState(this.response);
}

class SigninErrorState extends SigninState {
  final String error;
  SigninErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

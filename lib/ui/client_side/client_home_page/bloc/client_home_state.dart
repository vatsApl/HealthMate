abstract class ClientHomeState {}

class ClientHomeInitialState extends ClientHomeState {}

class ClientHomeLoadingState extends ClientHomeState {}

class ClientHomeLoadedState extends ClientHomeState {
  dynamic response;
  ClientHomeLoadedState(this.response);
}

class ClientHomeErrorState extends ClientHomeState {
  final String error;
  ClientHomeErrorState({required this.error});
}

abstract class ClientPersonalDetialsState {}

class ShowClientPersonalDetailsInitialState
    extends ClientPersonalDetialsState {}

class ShowClientPersonalDetailsLoadingState
    extends ClientPersonalDetialsState {}

class ShowClientPersonalDetailsLoadedState extends ClientPersonalDetialsState {
  dynamic response;
  ShowClientPersonalDetailsLoadedState(this.response);
}

class ShowClientPersonalDetailsErrorState extends ClientPersonalDetialsState {
  final String error;
  ShowClientPersonalDetailsErrorState({required this.error});
}

class UpdateClientDetailsLoadingState extends ClientPersonalDetialsState {}

class UpdateClientDetailsLoadedState extends ClientPersonalDetialsState {
  dynamic response;
  UpdateClientDetailsLoadedState(this.response);
}

class UpdateClientDetailsErrorState extends ClientPersonalDetialsState {
  final String error;
  UpdateClientDetailsErrorState({required this.error});
}

class UploadFileToServerLoadingState extends ClientPersonalDetialsState {}

class UploadFileToServerLoadedState extends ClientPersonalDetialsState {
  dynamic response;
  UploadFileToServerLoadedState(this.response);
}

class UploadFileToServerErrorState extends ClientPersonalDetialsState {
  final String error;
  UploadFileToServerErrorState({required this.error});
}

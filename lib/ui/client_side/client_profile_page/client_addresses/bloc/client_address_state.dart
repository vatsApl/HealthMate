abstract class ClientAddressState {}

class ClientAddressInitialState extends ClientAddressState {}

class ClientAddressLoadingState extends ClientAddressState {}

class ClientAddressLoadedState extends ClientAddressState {
  dynamic response;
  ClientAddressLoadedState(this.response);
}

class ClientAddressErrorState extends ClientAddressState {
  final String error;
  ClientAddressErrorState({required this.error});
}

class SetAsDefaultAddressLoadingState extends ClientAddressState {}

class SetAsDefaultAddressLoadedState extends ClientAddressState {
  dynamic response;
  SetAsDefaultAddressLoadedState(this.response);
}

class SetAsDefaultAddressErrorState extends ClientAddressState {
  final String error;
  SetAsDefaultAddressErrorState({required this.error});
}

class RemoveAddressLoadingState extends ClientAddressState {}

class RemoveAddressLoadedState extends ClientAddressState {
  dynamic response;
  RemoveAddressLoadedState(this.response);
}

class RemoveAddressErrorState extends ClientAddressState {
  final String error;
  RemoveAddressErrorState({required this.error});
}

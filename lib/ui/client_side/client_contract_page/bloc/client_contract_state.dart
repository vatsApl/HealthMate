abstract class ClientContractState {}

class ClientContractInitialState extends ClientContractState {}

class ClientContractLoadingState extends ClientContractState {}

class ClientContractLoadedState extends ClientContractState {
  dynamic response;
  ClientContractLoadedState(this.response);
}

class ClientContractErrorState extends ClientContractState {
  final String error;
  ClientContractErrorState({required this.error});
}

abstract class ClientJobDescState {}

class ShowJobDescInitialState extends ClientJobDescState {}

class ShowJobDescLoadingState extends ClientJobDescState {}

class RemoveContractLoadingState extends ClientJobDescState {}

class ShowJobDescLoadedState extends ClientJobDescState {
  dynamic response;
  ShowJobDescLoadedState(this.response);
}

class RemoveContractLoadedState extends ClientJobDescState {
  dynamic response;
  RemoveContractLoadedState(this.response);
}

class ShowJobDescErrorState extends ClientJobDescState {
  final String error;
  ShowJobDescErrorState({required this.error});
}

class RemoveContractErrorState extends ClientJobDescState {
  final String error;
  RemoveContractErrorState({required this.error});
}

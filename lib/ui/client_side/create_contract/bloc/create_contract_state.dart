abstract class CreateContractState {}

class CreateContractInitialState extends CreateContractState {}

class CreateContractLoadingState extends CreateContractState {}

class CreateContractLoadedState extends CreateContractState {
  var response;
  CreateContractLoadedState(this.response);
}

class AddressesLoadingState extends CreateContractState {}

class AddressesLoadedState extends CreateContractState {
  var response;
  AddressesLoadedState(this.response);
}

class AddressesErrorState extends CreateContractState {
  final String error;
  AddressesErrorState({required this.error});
}

class CreateContractErrorState extends CreateContractState {
  final String error;
  CreateContractErrorState({required this.error});
}

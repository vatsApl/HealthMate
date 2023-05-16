abstract class AddNewAddressCreateContractState {}

class AddNewAddressCreateContractInitial
    extends AddNewAddressCreateContractState {}

class AddNewAddressCreateContractLoading
    extends AddNewAddressCreateContractState {}

class AddNewAddressCreateContractLoaded
    extends AddNewAddressCreateContractState {
  dynamic response;
  AddNewAddressCreateContractLoaded(this.response);
}

class AddNewAddressCreateContractError
    extends AddNewAddressCreateContractState {
  final String error;
  AddNewAddressCreateContractError({required this.error});
}

abstract class CreateContractEvent {}

class CreateContractSubmitButtonPressed extends CreateContractEvent {
  Map<String, dynamic> params;
  CreateContractSubmitButtonPressed(this.params);
}

class ShowAllAddressesApi extends CreateContractEvent {
  String uId;
  ShowAllAddressesApi(this.uId);
}

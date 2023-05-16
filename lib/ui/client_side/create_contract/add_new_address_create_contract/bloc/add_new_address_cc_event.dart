abstract class AddNewAddressCreateContractEvent {}

class AddNewAddressOnSubmitCreateContract
    extends AddNewAddressCreateContractEvent {
  Map<String, dynamic> params;
  AddNewAddressOnSubmitCreateContract(this.params);
}

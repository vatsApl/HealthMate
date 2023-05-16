abstract class AddNewAddressState {}

class AddNewAddressInitialState extends AddNewAddressState {}

class AddNewAddressLoadingState extends AddNewAddressState {}

class AddNewAddressLoadedState extends AddNewAddressState {
  dynamic response;
  AddNewAddressLoadedState(this.response);
}

class AddNewAddressErrorState extends AddNewAddressState {
  final String error;
  AddNewAddressErrorState({required this.error});
}

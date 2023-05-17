abstract class EditAddressState {}

class ShowEditAddressInitialState extends EditAddressState {}

class ShowEditAddressLoadingState extends EditAddressState {}

class ShowEditAddressLoadedState extends EditAddressState {
  dynamic response;
  ShowEditAddressLoadedState(this.response);
}

class ShowEditAddressErrorState extends EditAddressState {
  final String error;
  ShowEditAddressErrorState({required this.error});
}

class UpdateAddressLoadingState extends EditAddressState {}

class UpdateAddressLoadedState extends EditAddressState {
  dynamic response;
  UpdateAddressLoadedState(this.response);
}

class UpdateAddressErrorState extends EditAddressState {
  final String error;
  UpdateAddressErrorState({required this.error});
}

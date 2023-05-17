abstract class EditAddressEvent {}

class ShowEditAddressEvent extends EditAddressEvent {
  String addId;
  ShowEditAddressEvent({required this.addId});
}

class UpdateAddressEvent extends EditAddressEvent {
  Map<String, dynamic> params;
  UpdateAddressEvent({required this.params});
}

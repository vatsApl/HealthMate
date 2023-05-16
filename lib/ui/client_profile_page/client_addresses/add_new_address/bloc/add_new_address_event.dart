abstract class AddNewAddressEvent {}

class AddNewAddressOnSubmitEvent extends AddNewAddressEvent {
  Map<String, dynamic> params;
  AddNewAddressOnSubmitEvent({required this.params});
}

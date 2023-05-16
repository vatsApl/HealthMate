abstract class ClientAddressEvent {}

class ShowAllAddressEvent extends ClientAddressEvent {
  String uId;
  ShowAllAddressEvent({required this.uId});
}

class SetAsDefaultAddressEvent extends ClientAddressEvent {
  Map<String, dynamic> params;
  SetAsDefaultAddressEvent({required this.params});
}

class RemoveAddressEvent extends ClientAddressEvent {
  String addressId;
  RemoveAddressEvent({required this.addressId});
}

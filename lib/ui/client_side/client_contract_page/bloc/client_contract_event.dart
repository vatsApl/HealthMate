abstract class ClientContractEvent {}

class ClientContractLoadEvent extends ClientContractEvent {
  int pageValue;
  ClientContractLoadEvent(this.pageValue);
}

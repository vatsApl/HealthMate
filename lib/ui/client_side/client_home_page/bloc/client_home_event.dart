abstract class ClientHomeEvent {}

class ClientHomeLoadDataEvent extends ClientHomeEvent {
  String uId;
  ClientHomeLoadDataEvent(this.uId);
}

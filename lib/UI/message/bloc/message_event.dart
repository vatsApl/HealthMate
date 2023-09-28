abstract class MessageEvent {}

class ShowMessageListEvent2 extends MessageEvent {
  int pageValue;
  ShowMessageListEvent2(this.pageValue);
}

abstract class MessageState {}

class MessageInititalState extends MessageState {}

class MessageLoadingState extends MessageState {}

class MessageLoadedState extends MessageState {
  dynamic response;
  MessageLoadedState(this.response);
}

class MessageErrorState extends MessageState {
  final String error;
  MessageErrorState({required this.error});
}

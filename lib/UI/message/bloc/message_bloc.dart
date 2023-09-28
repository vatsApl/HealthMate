import 'package:clg_project/UI/message/bloc/message_event.dart';
import 'package:clg_project/UI/message/bloc/message_state.dart';
import 'package:clg_project/UI/message/repo/message_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository _messageRepository;
  MessageBloc(this._messageRepository) : super(MessageInititalState()) {
    on<MessageEvent>((event, emit) async {
      if (event is ShowMessageListEvent2) {
        emit(MessageLoadingState());
        try {
          var response = await _messageRepository.showMessageListApi(
              pageValue: event.pageValue);
          emit(MessageLoadedState(response));
        } catch (e) {
          print('server off');
          emit(MessageErrorState(error: e.toString()));
        }
      }
    });
  }
}

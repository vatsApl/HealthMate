import 'package:clg_project/ui/client_side/client_home_page/bloc/client_home_event.dart';
import 'package:clg_project/ui/client_side/client_home_page/bloc/client_home_state.dart';
import 'package:clg_project/ui/client_side/client_home_page/repo/client_home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientHomeBloc extends Bloc<ClientHomeEvent, ClientHomeState> {
  final ClientHomeRepository _clientHomeRepository;
  ClientHomeBloc(this._clientHomeRepository) : super(ClientHomeInitialState()) {
    on<ClientHomeEvent>((event, emit) async {
      if (event is ClientHomeLoadDataEvent) {
        emit(ClientHomeLoadingState());
        try {
          var response =
              await _clientHomeRepository.showContractHomeApi(uId: event.uId);
          emit(ClientHomeLoadedState(response));
        } catch (e) {
          print('server off');
          emit(ClientHomeErrorState(error: e.toString()));
        }
      }
    });
  }
}

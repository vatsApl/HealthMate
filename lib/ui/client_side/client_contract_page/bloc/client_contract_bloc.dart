import 'package:clg_project/ui/client_side/client_contract_page/bloc/client_contract_event.dart';
import 'package:clg_project/ui/client_side/client_contract_page/bloc/client_contract_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/client_contract_repository.dart';

class ClientContractBloc
    extends Bloc<ClientContractEvent, ClientContractState> {
  final ClientContractRepository _clientContractRepository;
  ClientContractBloc(this._clientContractRepository)
      : super(ClientContractInitialState()) {
    on<ClientContractEvent>((event, emit) async {
      if (event is ClientContractLoadEvent) {
        emit(ClientContractLoadingState());
        try {
          var response = await _clientContractRepository.showContractApi(
              pageValue: event.pageValue);
          emit(ClientContractLoadedState(response));
        } catch (e) {
          emit(ClientContractErrorState(error: e.toString()));
        }
      }
    });
  }
}

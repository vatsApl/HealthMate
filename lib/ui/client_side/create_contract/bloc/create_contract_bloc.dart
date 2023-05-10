import 'package:clg_project/ui/client_side/create_contract/bloc/create_contract_event.dart';
import 'package:clg_project/ui/client_side/create_contract/bloc/create_contract_state.dart';
import 'package:clg_project/ui/client_side/create_contract/repo/create_contract_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateContractBloc
    extends Bloc<CreateContractEvent, CreateContractState> {
  final CreateContractRepository _createContractRepository;
  CreateContractBloc(this._createContractRepository)
      : super(CreateContractInitialState()) {
    on<CreateContractEvent>((event, emit) async {
      if (event is CreateContractSubmitButtonPressed) {
        emit(CreateContractLoadingState());
        try {
          var response =
              await _createContractRepository.createContractApi(event.params);
          emit(CreateContractLoadedState(response));
        } catch (e) {
          emit(CreateContractErrorState(error: e.toString()));
        }
      }

      if (event is ShowAllAddressesApi) {
        emit(AddressesLoadingState());
        try {
          var response =
              await _createContractRepository.allAddressesApi(event.uId);
          emit(AddressesLoadedState(response));
        } catch (e) {
          emit(AddressesErrorState(error: e.toString()));
        }
      }
    });
  }
}

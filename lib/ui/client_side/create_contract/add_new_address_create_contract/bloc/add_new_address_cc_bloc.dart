import 'package:clg_project/ui/client_side/create_contract/add_new_address_create_contract/bloc/add_new_address_cc_event.dart';
import 'package:clg_project/ui/client_side/create_contract/add_new_address_create_contract/bloc/add_new_address_cc_state.dart';
import 'package:clg_project/ui/client_side/create_contract/add_new_address_create_contract/repo/add_new_address_cc_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewAddressCreateContractBloc extends Bloc<
    AddNewAddressCreateContractEvent, AddNewAddressCreateContractState> {
  final AddNewAddressCCRepository _addNewAddressCCRepository;
  AddNewAddressCreateContractBloc(this._addNewAddressCCRepository)
      : super(AddNewAddressCreateContractInitial()) {
    on<AddNewAddressCreateContractEvent>((event, emit) async {
      if (event is AddNewAddressOnSubmitCreateContract) {
        emit(AddNewAddressCreateContractLoading());
        try {
          var response = await _addNewAddressCCRepository.addNewAddressApi(
              params: event.params);
          emit(AddNewAddressCreateContractLoaded(response));
        } catch (e) {
          emit(AddNewAddressCreateContractError(error: e.toString()));
        }
      }
    });
  }
}

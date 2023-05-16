import 'package:clg_project/ui/client_profile_page/client_addresses/add_new_address/bloc/add_new_address_event.dart';
import 'package:clg_project/ui/client_profile_page/client_addresses/add_new_address/bloc/add_new_address_state.dart';
import 'package:clg_project/ui/client_profile_page/client_addresses/add_new_address/repo/add_new_address_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewAddressBloc extends Bloc<AddNewAddressEvent, AddNewAddressState> {
  final AddNewAddressRepository _addNewAddressRepository;
  AddNewAddressBloc(this._addNewAddressRepository)
      : super(AddNewAddressInitialState()) {
    on<AddNewAddressEvent>((event, emit) async {
      if (event is AddNewAddressOnSubmitEvent) {
        emit(AddNewAddressLoadingState());
        try {
          var response = await _addNewAddressRepository.addNewAddressApi(
              params: event.params);
          emit(AddNewAddressLoadedState(response));
        } catch (e) {
          emit(AddNewAddressErrorState(error: e.toString()));
        }
      }
    });
  }
}

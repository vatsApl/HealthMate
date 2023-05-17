import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/edit_address_repository.dart';
import 'edit_address_event.dart';
import 'edit_address_state.dart';

class EditAddressBloc extends Bloc<EditAddressEvent, EditAddressState> {
  final EditAddressRepository _editAddressRepository;
  EditAddressBloc(this._editAddressRepository)
      : super(ShowEditAddressInitialState()) {
    on<EditAddressEvent>((event, emit) async {
      if (event is ShowEditAddressEvent) {
        emit(ShowEditAddressLoadingState());
        try {
          var response =
              await _editAddressRepository.editAddressApi(event.addId);
          emit(ShowEditAddressLoadedState(response));
        } catch (e) {
          emit(ShowEditAddressLoadedState(e.toString()));
        }
      }

      if (event is UpdateAddressEvent) {
        emit(UpdateAddressLoadingState());
        try {
          var response = await _editAddressRepository.updateAddressApi(
              params: event.params);
          emit(UpdateAddressLoadedState(response));
        } catch (e) {
          emit(UpdateAddressErrorState(error: e.toString()));
        }
      }
    });
  }
}

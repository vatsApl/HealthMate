import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/add_new_address_repo.dart';
import 'add_new_address_event.dart';
import 'add_new_address_state.dart';

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

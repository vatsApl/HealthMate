import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/client_address_repo.dart';
import 'client_address_event.dart';
import 'client_address_state.dart';

class ClientAddressBloc extends Bloc<ClientAddressEvent, ClientAddressState> {
  final ClientAddressRepository _clientAddressRepository;
  ClientAddressBloc(this._clientAddressRepository)
      : super(ClientAddressInitialState()) {
    on<ClientAddressEvent>((event, emit) async {
      if (event is ShowAllAddressEvent) {
        emit(ClientAddressLoadingState());
        try {
          var response =
              await _clientAddressRepository.allAddressesApi(event.uId);
          emit(ClientAddressLoadedState(response));
        } catch (e) {
          emit(ClientAddressErrorState(error: e.toString()));
        }
      }

      if (event is SetAsDefaultAddressEvent) {
        emit(SetAsDefaultAddressLoadingState());
        try {
          var response = await _clientAddressRepository.setAsDefaultAddressApi(
              params: event.params);
          emit(SetAsDefaultAddressLoadedState(response));
        } catch (e) {
          emit(SetAsDefaultAddressErrorState(error: e.toString()));
        }
      }

      if (event is RemoveAddressEvent) {
        emit(RemoveAddressLoadingState());
        try {
          var response = await _clientAddressRepository.removeAddressApi(
              addressId: event.addressId);
          emit(RemoveAddressLoadedState(response));
        } catch (e) {
          emit(RemoveAddressErrorState(error: e.toString()));
        }
      }
    });
  }
}

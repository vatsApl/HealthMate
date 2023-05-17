import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/client_personal_details_repo.dart';
import 'client_personal_details_event.dart';
import 'client_personal_details_state.dart';

class ClientPersonalDetailsBloc
    extends Bloc<ClientPersonalDetailsEvent, ClientPersonalDetialsState> {
  final ClientPersonalDetailsRepo _clientPersonalDetailsRepo;
  ClientPersonalDetailsBloc(this._clientPersonalDetailsRepo)
      : super(ShowClientPersonalDetailsInitialState()) {
    on<ClientPersonalDetailsEvent>((event, emit) async {
      if (event is ShowClientPersonalDetails) {
        emit(ShowClientPersonalDetailsLoadingState());
        try {
          var response = await _clientPersonalDetailsRepo
              .clientPersonalDetailsApi(uId: event.uId);
          emit(ShowClientPersonalDetailsLoadedState(response));
        } catch (e) {
          emit(ShowClientPersonalDetailsErrorState(error: e.toString()));
        }
      }

      if (event is UpdateClientDetails) {
        emit(UpdateClientDetailsLoadingState());
        try {
          var response = await _clientPersonalDetailsRepo
              .updateClientDetailsApi(params: event.params);
          emit(UpdateClientDetailsLoadedState(response));
        } catch (e) {
          emit(UpdateClientDetailsErrorState(error: e.toString()));
        }
      }

      if (event is uploadFileToServer) {
        emit(UploadFileToServerLoadingState());
        try {
          var response = await _clientPersonalDetailsRepo.uploadFileToServerApi(
              uId: event.uId, imageFile: event.imageFile);
          emit(UploadFileToServerLoadedState(response));
        } catch (e) {
          emit(UploadFileToServerErrorState(error: e.toString()));
        }
      }
    });
  }
}

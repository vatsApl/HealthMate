import 'package:clg_project/ui/client_side/client_home_page/client_job_description/bloc/client_job_desc_event.dart';
import 'package:clg_project/ui/client_side/client_home_page/client_job_description/bloc/client_job_desc_state.dart';
import 'package:clg_project/ui/client_side/client_home_page/client_job_description/repo/client_job_desc_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientJobDescBloc extends Bloc<ClientJobDescEvent, ClientJobDescState> {
  final ClientJobDescRepository _clientJobDescRepository;
  ClientJobDescBloc(this._clientJobDescRepository)
      : super(ShowJobDescInitialState()) {
    on<ClientJobDescEvent>((event, emit) async {
      if (event is ShowJobDescEvent) {
        emit(ShowJobDescLoadingState());
        try {
          var response = await _clientJobDescRepository.jobDescriptionApi(
              jobId: event.jobId);
          emit(ShowJobDescLoadedState(response));
        } catch (e) {
          emit(ShowJobDescErrorState(error: e.toString()));
        }
      }

      if (event is RemoveContractEvent) {
        emit(RemoveContractLoadingState());
        try {
          var response = await _clientJobDescRepository.removeContractApi(
              jobId: event.jobId);
          emit(RemoveContractLoadedState(response));
        } catch (e) {
          emit(RemoveContractErrorState(error: e.toString()));
        }
      }
    });
  }
}

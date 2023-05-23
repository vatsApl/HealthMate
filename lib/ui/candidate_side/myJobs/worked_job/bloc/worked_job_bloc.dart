import 'package:clg_project/ui/candidate_side/myJobs/worked_job/bloc/worked_job_event.dart';
import 'package:clg_project/ui/candidate_side/myJobs/worked_job/bloc/worked_job_state.dart';
import 'package:clg_project/ui/candidate_side/myJobs/worked_job/repo/worked_job_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkedJobBloc extends Bloc<WorkedJobEvent, WorkedJobState> {
  final WorkedJobRepository _workedJobRepository;
  WorkedJobBloc(this._workedJobRepository)
      : super(ShowWorkedJobInitialState()) {
    on<WorkedJobEvent>((event, emit) async {
      if (event is ShowWorkedJobEvent) {
        emit(ShowWorkedJobLoadingState());
        try {
          var response = await _workedJobRepository.workedJobApi(
              pageValue: event.pageValue);
          emit(ShowWorkedJobLoadedState(response));
        } catch (e) {
          emit(ShowWorkedJobErrorState(error: e.toString()));
        }
      }

      if (event is showAmountStatusEvent) {
        emit(ShowAmountStatusLoading());
        try {
          var response =
              await _workedJobRepository.showAmountStatusWorkedJobApi();
          emit(ShowAmountStatusLoadedState(response));
        } catch (e) {
          emit(ShowAmountStatusErrorState(error: e.toString()));
        }
      }
    });
  }
}

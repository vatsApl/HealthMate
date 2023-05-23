import 'package:clg_project/ui/candidate_side/myJobs/worked_job/worked_job_description/bloc/worked_job_desc_event.dart';
import 'package:clg_project/ui/candidate_side/myJobs/worked_job/worked_job_description/bloc/worked_job_desc_state.dart';
import 'package:clg_project/ui/candidate_side/myJobs/worked_job/worked_job_description/repo/worked_job_desc_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WorkedJobDescBloc extends Bloc<WorkedJobDescEvent, WorkedJobDescState> {
  final WorkedJobDescRepository _workedJobDescRepository;
  WorkedJobDescBloc(this._workedJobDescRepository)
      : super(ShowWorkedJobDescInitialState()) {
    on<WorkedJobDescEvent>((event, emit) async {
      if (event is ShowWorkedJobDescEvent) {
        emit(ShowWorkedJobDescLoadingState());
        try {
          var response = await _workedJobDescRepository.workedJobDescriptionApi(
              jobId: event.jobId);
          emit(ShowWorkedJobDescLoadedState(response));
        } catch (e) {
          emit(ShowWorkedJobDescErrorState(error: e.toString()));
        }
      }

      if (event is EditTimesheetAfterDisputeEvent) {
        emit(EditTimesheetAfterDisputeLoadingState());
        try {
          var response = await _workedJobDescRepository
              .editTimesheetAfterDisputeApi(timesheetId: event.timesheetId);
          emit(EditTimesheetAfterDisputeLoadedState(response));
        } catch (e) {
          emit(EditTimesheetAfterDisputeErrorState(error: e.toString()));
        }
      }
    });
  }
}

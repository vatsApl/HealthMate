import 'package:clg_project/ui/client_side/client_verification_pages/job_timesheets/job_timesheet_desc/bloc/timesheet_desc_state.dart';
import 'package:clg_project/ui/client_side/client_verification_pages/job_timesheets/job_timesheet_desc/repo/timesheet_desc_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'timesheet_desc_event.dart';

class TimesheetDescBloc extends Bloc<TimesheetDescEvent, TimesheetDescState> {
  final TimesheetDescRepository _timesheetDescRepository;
  TimesheetDescBloc(this._timesheetDescRepository)
      : super(TimesheetDescInitialState()) {
    on<TimesheetDescEvent>((event, emit) async {
      if (event is ShowTimesheetDescEvent) {
        emit(TimesheetDescLoadingState());
        try {
          var response =
              await _timesheetDescRepository.timesheetDescApi(event.jobId);
          emit(TimesheetDescLoadedState(response));
        } catch (e) {
          emit(TimesheetDescErrorState(error: e.toString()));
        }
      }

      if (event is ApproveTimesheetEvent) {
        emit(ApproveTimesheetLoadingState());
        try {
          var response = await _timesheetDescRepository
              .approveTimeSheetApi(event.timesheetId);
          emit(ApproveTimesheetLoadedState(response));
        } catch (e) {
          emit(ApproveTimesheetErrorState(error: e.toString()));
        }
      }

      if (event is RejectTimesheetApi) {
        emit(RejectTimesheetLoadingState());
        try {
          var response = await _timesheetDescRepository.rejectTimeSheetApi(
              params: event.params);
          emit(RejectTimesheetLoadedState(response));
        } catch (e) {
          emit(RejectTimesheetErrorState(error: e.toString()));
        }
      }
    });
  }
}

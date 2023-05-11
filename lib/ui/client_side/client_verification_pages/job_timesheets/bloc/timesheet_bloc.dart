import 'package:clg_project/ui/client_side/client_verification_pages/job_timesheets/bloc/timesheet_event.dart';
import 'package:clg_project/ui/client_side/client_verification_pages/job_timesheets/bloc/timesheet_state.dart';
import 'package:clg_project/ui/client_side/client_verification_pages/job_timesheets/repo/timesheet_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimesheetBloc extends Bloc<TimesheetEvent, TimesheetState> {
  final TimesheetRepository _timesheetRepository;
  TimesheetBloc(this._timesheetRepository) : super(TimesheetInitialState()) {
    on<TimesheetEvent>((event, emit) async {
      if (event is ShowTimesheetEvent) {
        emit(TimesheetLoadingState());
        try {
          var response = await _timesheetRepository.timesheetJobApi(
              pageValue: event.pageValue, status: event.status);
          emit(TimesheetLoadedState(response));
        } catch (e) {
          emit(TimesheetErrorState(error: e.toString()));
        }
      }
    });
  }
}

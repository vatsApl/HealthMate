import 'package:clg_project/ui/candidate_side/myJobs/applied_job/my_job_desc/bloc/my_job_desc_event.dart';
import 'package:clg_project/ui/candidate_side/myJobs/applied_job/my_job_desc/bloc/my_job_desc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/my_job_desc_repo.dart';

class MyJobDescBloc extends Bloc<MyJobDescEvent, MyJobDescState> {
  final MyJobDescRepository _myJobDescRepository;
  MyJobDescBloc(this._myJobDescRepository)
      : super(ShowMyJobDescInitialState()) {
    on<MyJobDescEvent>((event, emit) async {
      if (event is ShowMyJobDescEvent) {
        emit(ShowMyJobDescLoadingState());
        try {
          var response = await _myJobDescRepository.myJobDescriptionApi(
              jobId: event.jobId);
          emit(ShowMyJobDescLoadedState(response));
        } catch (e) {
          emit(ShowMyJobDescErrorState(error: e.toString()));
        }
      }

      if (event is WithdrawJobEvent) {
        emit(WithdrawJobLoadingState());
        try {
          var response =
              await _myJobDescRepository.withdrawJobApi(appId: event.appId);
          emit(WithdrawJobLoadedState(response));
        } catch (e) {
          emit(WithdrawJobErrorState(error: e.toString()));
        }
      }

      if (event is EditTimesheetEvent) {
        emit(EditTimesheetLoadingState());
        try {
          var response = await _myJobDescRepository.editTimesheetApi(
              timesheetId: event.timesheetId);
          emit(EditTimesheetLoadedState(response));
        } catch (e) {
          emit(EditTimesheetErrorState(error: e.toString()));
        }
      }
    });
  }
}

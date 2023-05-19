import 'package:clg_project/ui/candidate_side/myJobs/booked_job/sign_off_page/bloc/sign_off_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/sign_off_repository.dart';
import 'sign_off_event.dart';

class SignOffBloc extends Bloc<SignOffEvent, SignOffState> {
  final SignOffRepository _signOffRepository;
  SignOffBloc(this._signOffRepository) : super(UpdateTimesheetInitialState()) {
    on<SignOffEvent>((event, emit) async {
      if (event is UpdateTimesheetEvent) {
        emit(UpdateTimesheetLoadingState());
        try {
          var response = await _signOffRepository.updateTimesheetApi(
            params: event.params,
            timesheetId: event.timesheetId,
          );
          emit(UpdateTimesheetLoadedState(response));
        } catch (e) {
          emit(UpdateTimesheetErrorState(error: e.toString()));
        }
      }
    });
  }
}

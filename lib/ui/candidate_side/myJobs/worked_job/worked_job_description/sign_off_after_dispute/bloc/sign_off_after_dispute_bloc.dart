import 'package:clg_project/ui/candidate_side/myJobs/worked_job/worked_job_description/sign_off_after_dispute/bloc/sign_off_after_dispute_event.dart';
import 'package:clg_project/ui/candidate_side/myJobs/worked_job/worked_job_description/sign_off_after_dispute/bloc/sign_off_after_dispute_state.dart';
import 'package:clg_project/ui/candidate_side/myJobs/worked_job/worked_job_description/sign_off_after_dispute/repo/sign_off_after_dispute_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignOffAfterDisputeBloc
    extends Bloc<SignOffAfterDisputeEvent, SignOffAfterDisputeState> {
  final SignOffAfterDisputeRepository _signOffAfterDisputeRepository;
  SignOffAfterDisputeBloc(this._signOffAfterDisputeRepository)
      : super(UpdateTimesheetAfterDisputeInitialState()) {
    on<SignOffAfterDisputeEvent>((event, emit) async {
      if (event is UpdateTimeSheetAfterDisputeEvent) {
        emit(UpdateTimesheetAfterDisputeLoadingState());
        try {
          var response = await _signOffAfterDisputeRepository
              .updateTimeSheetAfterDisputeApi(params: event.params);
          emit(UpdateTimesheetAfterDisputeLoadedState(response));
        } catch (e) {
          emit(UpdateTimesheetAfterDisputeErrorState(error: e.toString()));
        }
      }
    });
  }
}

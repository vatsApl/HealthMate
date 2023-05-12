import 'package:clg_project/ui/client_side/client_verification_pages/job_approvals/job_approvals_desc/bloc/job_approvals_desc_event.dart';
import 'package:clg_project/ui/client_side/client_verification_pages/job_approvals/job_approvals_desc/bloc/job_approvals_desc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/job_desc_approvals_repo.dart';

class JobApprovalsDescBloc
    extends Bloc<JobApprovalsDescEvent, JobApprovalsDescState> {
  final JobApprovalsDescRepository _jobApprovalsDescRepository;
  JobApprovalsDescBloc(this._jobApprovalsDescRepository)
      : super(ShowJobApprovalsDescInitialState()) {
    on<JobApprovalsDescEvent>((event, emit) async {
      if (event is ShowJobApprovalsDescEvent) {
        emit(ShowJobApprovalsDescLoadingState());
        try {
          var response = await _jobApprovalsDescRepository.jobDescapprovalsApi(
              jobId: event.jobId);
          emit(ShowJobApprovalsDescLoadedState(response));
        } catch (e) {
          emit(ShowJobApprovalsDescErrorState(error: e.toString()));
        }
      }

      if (event is ApproveApplicationEvent) {
        emit(ApproveApplicationLoadingState());
        try {
          var response = await _jobApprovalsDescRepository
              .approveApplicationGenerateTimesheetApi(
            candidateId: event.candidateId,
            jobId: event.jobId,
            applicationId: event.applicationId,
          );
          emit(ApproveApplicationLoadedState(response));
        } catch (e) {
          emit(ApproveApplicationErrorState(error: e.toString()));
        }
      }
    });
  }
}

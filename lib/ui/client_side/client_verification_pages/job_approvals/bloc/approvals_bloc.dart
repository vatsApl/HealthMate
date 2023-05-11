import 'package:clg_project/ui/client_side/client_verification_pages/job_approvals/bloc/approvals_event.dart';
import 'package:clg_project/ui/client_side/client_verification_pages/job_approvals/bloc/approvals_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/approvals_repository.dart';

class ApprovalsBloc extends Bloc<ApprovalsEvent, ApprovalsState> {
  final JobApprovalsRepository _jobApprovalsRepository;
  ApprovalsBloc(this._jobApprovalsRepository) : super(ApprovalsInitialState()) {
    on<ApprovalsEvent>((event, emit) async {
      if (event is ShowApprovalsEvent) {
        emit(ApprovalsLoadingState());
        try {
          var response = await _jobApprovalsRepository.approvalsJobApi(
            pageValue: event.pageValue,
            uId: event.uId,
            status: event.status,
          );
          emit(ApprovalsLoadedState(response));
        } catch (e) {
          emit(ApprovalsErrorState(error: e.toString()));
        }
      }
    });
  }
}

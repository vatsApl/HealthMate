import 'package:clg_project/ui/candidate_side/myJobs/applied_job/bloc/applied_job_event.dart';
import 'package:clg_project/ui/candidate_side/myJobs/applied_job/bloc/applied_job_state.dart';
import 'package:clg_project/ui/candidate_side/myJobs/applied_job/repo/applied_job_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppliedJobBloc extends Bloc<AppliedJobEvent, AppliedJobState> {
  final AppliedJobRepository _appliedJobRepository;
  AppliedJobBloc(this._appliedJobRepository)
      : super(ShowAppliedJobInitialState()) {
    on<AppliedJobEvent>((event, emit) async {
      if (event is ShowAppliedJobEvent) {
        emit(ShowAppliedJobLoadingState());
        try {
          var response = await _appliedJobRepository.appliedJobApi(
            params: event.params,
            pageValue: event.pageValue,
          );
          emit(ShowAppliedJobLoadedState(response));
        } catch (e) {
          emit(ShowApliedJobErrorState(error: e.toString()));
        }
      }
    });
  }
}

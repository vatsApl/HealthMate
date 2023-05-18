import 'package:clg_project/ui/candidate_side/candidate_home_page/candidate_job_description/bloc/job_desc_event.dart';
import 'package:clg_project/ui/candidate_side/candidate_home_page/candidate_job_description/bloc/job_desc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/job_desc_repository.dart';

class JobDescBloc extends Bloc<JobDescEvent, JobDescState> {
  final JobDescriptionRepository _jobDescriptionRepository;
  JobDescBloc(this._jobDescriptionRepository) : super(JobDescInitialState()) {
    on<JobDescEvent>((event, emit) async {
      if (event is ShowJobDescEvent) {
        emit(JobDescLoadingState());
        try {
          var response = await _jobDescriptionRepository.jobDescriptionApi(
              jobId: event.jobId);
          emit(JobDescLoadedState(response));
        } catch (e) {
          emit(JobDescErrorState(error: e.toString()));
        }
      }

      if (event is ApplyJobEvent) {
        emit(ApplyJobLoadingState());
        try {
          var response =
              await _jobDescriptionRepository.applyJobApi(params: event.params);
          emit(ApplyJobLoadedState(response));
        } catch (e) {
          emit(ApplyJobErrorState(error: e.toString()));
        }
      }
    });
  }
}

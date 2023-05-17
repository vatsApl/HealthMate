import 'package:clg_project/ui/candidate_side/find_job/bloc/find_job_event.dart';
import 'package:clg_project/ui/candidate_side/find_job/bloc/find_job_state.dart';
import 'package:clg_project/ui/candidate_side/find_job/repo/find_job_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FindJobBloc extends Bloc<FindJobEvent, FindJobState> {
  final FindJobRepository _findJobRepository;
  FindJobBloc(this._findJobRepository) : super(FindJobInitialState()) {
    on<FindJobEvent>((event, emit) async {
      if (event is ShowFindJobEvent) {
        emit(FindJobLoadingState());
        try {
          var response = await _findJobRepository.findJobApi(event.pageValue);
          emit(FindJobLoadedState(response));
        } catch (e) {
          emit(FindJobErrorState(error: e.toString()));
        }
      }
    });
  }
}

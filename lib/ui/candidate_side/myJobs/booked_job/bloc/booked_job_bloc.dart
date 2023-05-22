import 'package:clg_project/ui/candidate_side/myJobs/booked_job/bloc/booked_job_event.dart';
import 'package:clg_project/ui/candidate_side/myJobs/booked_job/bloc/booked_job_state.dart';
import 'package:clg_project/ui/candidate_side/myJobs/booked_job/repo/booked_job_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookedJobBloc extends Bloc<BookedJobEvent, BookedJobState> {
  final BookedJobRepository _bookedJobRepository;
  BookedJobBloc(this._bookedJobRepository)
      : super(ShowBookedJobInitialState()) {
    on<BookedJobEvent>((event, emit) async {
      if (event is ShowBookedJobEvent) {
        emit(ShowBookedJobLoadingState());
        try {
          var response = await _bookedJobRepository.bookedJobApi(
              pageValue: event.pageValue);
          emit(ShowBookedJobLoadedState(response));
        } catch (e) {
          emit(ShowBookedJobErrorState(error: e.toString()));
        }
      }
    });
  }
}

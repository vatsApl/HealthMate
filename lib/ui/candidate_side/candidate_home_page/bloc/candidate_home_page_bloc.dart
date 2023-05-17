import 'package:clg_project/ui/candidate_side/candidate_home_page/bloc/candidate_home_page_state.dart';
import 'package:clg_project/ui/candidate_side/candidate_home_page/repo/candidate_home_page_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'candidate_home_page_event.dart';

class CandidateHomePageBloc
    extends Bloc<CandidateHomePageEvent, CandidateHomePageState> {
  final CandidateHomePageRepo _candidateHomePageRepo;
  CandidateHomePageBloc(this._candidateHomePageRepo)
      : super(CandidateHomePageInitialState()) {
    on<CandidateHomePageEvent>((event, emit) async {
      if (event is ShowCandidateHomePageData) {
        emit(CandidateHomePageLoadingState());
        try {
          var response = await _candidateHomePageRepo.homePageCandidateApi();
          emit(CandidateHomePageLoadedState(response));
        } catch (e) {
          emit(CandidateHomePageErrorState(error: e.toString()));
        }
      }
    });
  }
}

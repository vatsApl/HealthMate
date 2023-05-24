import 'package:flutter_bloc/flutter_bloc.dart';

import '../repo/candidate_personal_details_repo.dart';
import 'candidate_personal_details_event.dart';
import 'candidate_personal_details_state.dart';

class CandidatePersonalDetailsBloc
    extends Bloc<CandidatePersonalDetailsEvent, CandidatePersonalDetailsState> {
  final CandidatePersonalDetailsRepository _candidatePersonalDetailsRepository;
  CandidatePersonalDetailsBloc(this._candidatePersonalDetailsRepository)
      : super(ShowCandidatePersonalDetailsInitialState()) {
    on<CandidatePersonalDetailsEvent>((event, emit) async {
      if (event is ShowCandidatePersonalDetailsEvent) {
        emit(ShowCandidatePersonalDetailsLoadingState());
        try {
          var response = await _candidatePersonalDetailsRepository
              .candidatePersonalDetailsApi();
          emit(ShowCandidatePersonalDetailsLoadedState(response));
        } catch (e) {
          emit(ShowCandidatePersonalDetailsErrorState(error: e.toString()));
        }
      }

      if (event is UpdateCandidateDetails) {
        emit(UpdateCandidateDetailsLoadingState());
        try {
          var response = await _candidatePersonalDetailsRepository
              .updateDetailsApi(params: event.params);
          emit(UpdateCandidateDetailsLoadedState(response));
        } catch (e) {
          emit(UpdateCandidateDetailsErrorState(error: e.toString()));
        }
      }

      if (event is CandidateUploadProfile) {
        emit(CandidateUploadProfileLoadingState());
        try {
          var response = await _candidatePersonalDetailsRepository
              .uploadCandidateProfileApi(imageFile: event.imageFile);
          emit(CandidateUploadProfileLoadedState(response));
        } catch (e) {
          emit(CandidateUploadProfileErrorState(error: e.toString()));
        }
      }
    });
  }
}

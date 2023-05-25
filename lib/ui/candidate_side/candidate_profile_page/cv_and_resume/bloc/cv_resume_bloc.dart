import 'package:clg_project/ui/candidate_side/candidate_profile_page/cv_and_resume/bloc/cv_resume_event.dart';
import 'package:clg_project/ui/candidate_side/candidate_profile_page/cv_and_resume/bloc/cv_resume_state.dart';
import 'package:clg_project/ui/candidate_side/candidate_profile_page/cv_and_resume/repo/cv_resume_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CvResumeBloc extends Bloc<CvResumeEvent, CvResumeState> {
  final CvResumeRepository _cvResumeRepository;
  CvResumeBloc(this._cvResumeRepository) : super(UploadCvInitialState()) {
    on<CvResumeEvent>((event, emit) async {
      if (event is UploadCvEvent) {
        emit(UploadCvLoadingState());
        try {
          var response = await _cvResumeRepository.uploadCvApi(
              filePathOfCv: event.filePathOfCv);
          emit(UploadCvLoadedState(response));
        } catch (e) {
          emit(UploadCvErrorState(error: e.toString()));
        }
      }
    });
  }
}

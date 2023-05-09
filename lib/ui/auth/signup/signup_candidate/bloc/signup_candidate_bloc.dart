import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/signup_candidate_repository.dart';
part 'signup_candidate_event.dart';
part 'signup_candidate_state.dart';

class SignupCandidateBloc
    extends Bloc<SignupCandidateEvent, SignupCandidateState> {
  final SignupCandidateRepository _signupCandidateRepository;
  SignupCandidateBloc(this._signupCandidateRepository)
      : super(SignupCandidateInitialState()) {
    on<SignupCandidateEvent>((event, emit) async {
      if (event is SignupCandidateButtonPressed) {
        emit(SignupCandidateLoadingState());
        try {
          var response = await _signupCandidateRepository.signUpCandidateApi(
            event.params,
          );
          emit(SignupCandidateLoadedState(response));
        } catch (e) {
          emit(SignupCandidateErrorState(error: e.toString()));
        }
      }
    });
  }
}

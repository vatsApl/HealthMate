import 'package:clg_project/ui/auth/user_verification/bloc/user_verification_event.dart';
import 'package:clg_project/ui/auth/user_verification/bloc/user_verification_state.dart';
import 'package:clg_project/ui/auth/user_verification/repo/user_verification_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserVerificationBloc
    extends Bloc<UserVerificationEvent, UserVerificationState> {
  final UserVerificationRepository _userVerificationRepository;
  UserVerificationBloc(this._userVerificationRepository)
      : super(UserVerificationInitialState()) {
    on<UserVerificationEvent>((event, emit) async {
      if (event is UserVerificationButtonPressed) {
        emit(UserVerificationLoadingState());
        try {
          var response =
              await _userVerificationRepository.signupOtpVerify(event.params);
          emit(UserVerificationLoadedState(response));
        } catch (e) {
          emit(UserVerificationErrorState(error: e.toString()));
        }
      }

      if (event is UserVerificationResendOtp) {
        emit(UserVerificationLoadingState());
        try {
          var response =
              await _userVerificationRepository.resendOtpSignup(event.params);
          emit(UserVerificationResendOtpLoadedState(response));
        } catch (e) {
          emit(UserVerificationErrorState(error: e.toString()));
        }
      }
    });
  }
}

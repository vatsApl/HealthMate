import 'package:clg_project/ui/auth/forgot_verification/bloc/forgot_verification_state.dart';
import 'package:clg_project/ui/auth/forgot_verification/bloc/forgot_verification_event.dart';
import 'package:clg_project/ui/auth/forgot_verification/repo/forgot_verification_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotVerificationBloc
    extends Bloc<ForgotVerificationEvent, ForgotVerificationState> {
  final ForgotVerificationRepository _forgotVerificationRepository;
  ForgotVerificationBloc(this._forgotVerificationRepository)
      : super(ForgotVerificationInitialState()) {
    on<ForgotVerificationEvent>((event, emit) async {
      if (event is ForgotVerificationVerifyEvent) {
        emit(ForgotVerificationLoadingState());
        try {
          var response = await _forgotVerificationRepository
              .verifyOtpForgotPasswordApi(event.params);
          emit(ForgotVerificationLoadedState(response));
        } catch (e) {
          emit(ForgotVerificationErrorState(error: e.toString()));
        }
      }

      if (event is ForgotVerificationResendEvent) {
        emit(ForgotVerificationLoadingState());
        try {
          var response = await _forgotVerificationRepository
              .forgotPasswordResendOtpApi(event.params);
          emit(ForgotVerificationResendLoadedState(response));
        } catch (e) {
          emit(ForgotVerificationErrorState(error: e.toString()));
        }
      }
    });
  }
}

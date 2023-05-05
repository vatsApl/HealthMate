import 'package:clg_project/ui/forgot_password/bloc/forgot_password_event.dart';
import 'package:clg_project/ui/forgot_password/bloc/forgot_password_state.dart';
import 'package:clg_project/ui/forgot_password/repo/forgot_password_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordRepository _forgotPasswordRepository;
  ForgotPasswordBloc(this._forgotPasswordRepository)
      : super(ForgotPasswordInitialState()) {
    on<ForgotPasswordEvent>((event, emit) async {
      if (event is ForgotPasswordButtonPressed) {
        emit(ForgotPasswordLoadingState());
        try {
          var response =
              await _forgotPasswordRepository.forgotPasswordApi(event.params);
          emit(ForgotPasswordLoadedState(response));
        } catch (e) {
          emit(ForgotPasswordErrorState(error: e.toString()));
        }
      }
    });
  }
}

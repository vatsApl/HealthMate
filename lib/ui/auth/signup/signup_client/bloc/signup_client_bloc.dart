import 'package:clg_project/ui/auth/signup/signup_client/repo/signup_client_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_client_event.dart';
import 'signup_client_state.dart';

class SignupClientBloc extends Bloc<SignupClientEvent, SignupClientState> {
  final SignupClientRepository _signupClientRepository;
  SignupClientBloc(this._signupClientRepository)
      : super(SignupClientInitialState()) {
    on<SignupClientEvent>((event, emit) async {
      if (event is SignupClientButtonPressed) {
        emit(SignupClientLoadingState());
        try {
          var response =
              await _signupClientRepository.signUpClientApi(event.params);
          emit(SignupClientLoadedState(response));
        } catch (e) {
          emit(SignupClientErrorState(error: e.toString()));
        }
      }
    });
  }
}

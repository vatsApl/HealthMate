import 'package:clg_project/ui/signin/bloc/signin_event.dart';
import 'package:clg_project/ui/signin/bloc/signin_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/signin_repository.dart';

class SigninBloc extends Bloc<SigninEvent, SigninState> {
  final SigninRepository _signinRepository;
  SigninBloc(this._signinRepository) : super(SigninInitialState()) {
    on<SigninEvent>((event, emit) async {
      if (event is SigninButtonPressed) {
        emit(SigninLoadingState());
        try {
          var response = await _signinRepository.signInApi(
            email: event.email,
            password: event.password,
          );
          emit(SigninLoadedState(response));
        } catch (e) {
          emit(SigninErrorState(error: e.toString()));
        }
      }
    });
  }
}

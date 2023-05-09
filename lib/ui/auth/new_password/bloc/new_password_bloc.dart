import 'package:clg_project/ui/auth/new_password/bloc/new_password_event.dart';
import 'package:clg_project/ui/auth/new_password/bloc/new_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/new_password_repository.dart';

class NewPasswordBloc extends Bloc<NewPasswordEvent, NewPasswordState> {
  final NewPasswordRepository _newPasswordRepository;
  NewPasswordBloc(this._newPasswordRepository)
      : super(NewPasswordInitialState()) {
    on<NewPasswordEvent>((event, emit) async {
      if (event is NewPasswordVerifyButtonPressed) {
        emit(NewPasswordLoadingState());
        try {
          var response =
              await _newPasswordRepository.resetPasswordApi(event.params);
          emit(NewPasswordLoadedState(response));
        } catch (e) {
          emit(NewPasswordErrorState(error: e.toString()));
        }
      }
    });
  }
}

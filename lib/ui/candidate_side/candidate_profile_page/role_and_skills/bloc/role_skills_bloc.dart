import 'package:clg_project/ui/candidate_side/candidate_profile_page/role_and_skills/bloc/role_skills_event.dart';
import 'package:clg_project/ui/candidate_side/candidate_profile_page/role_and_skills/bloc/role_skills_state.dart';
import 'package:clg_project/ui/candidate_side/candidate_profile_page/role_and_skills/repo/role_skills_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoleAndSkillsBloc extends Bloc<RoleAndSkillsEvent, RoleAndSkillsState> {
  final RoleAndSkillsRepository _roleAndSkillsRepository;
  RoleAndSkillsBloc(this._roleAndSkillsRepository)
      : super(ShowRoleAndSkillsInitialState()) {
    on<RoleAndSkillsEvent>((event, emit) async {
      if (event is ShowRoleAndSkillsEvent) {
        emit(ShowRoleAndSkillsLoadingState());
        try {
          var response = await _roleAndSkillsRepository.showRoleAndSkillsApi();
          emit(ShowRoleAndSkillsLoadedState(response));
        } catch (e) {
          emit(ShowRoleAndSkillsErrorState(error: e.toString()));
        }
      }

      if (event is UpdateRoleEvent) {
        emit(UpdateRoleLoadingState());
        try {
          var response = await _roleAndSkillsRepository.updateRoleApi(
              params: event.params);
          emit(UpdateRoleLoadedState(response));
        } catch (e) {
          emit(UpdateRoleErrorState(error: e.toString()));
        }
      }

      if (event is OnChangeSkillsEvent) {
        emit(OnChangeSkillsLoadingState());
        try {
          var response = await _roleAndSkillsRepository.onchangeSkillsApi(
              selectedRoleIndexOnchangeSkills:
                  event.selectedRoleIndexOnchangeSkills);
          emit(OnChangeSkillsLoadedState(response));
        } catch (e) {
          emit(OnChangeSkillsErrorState(error: e.toString()));
        }
      }
    });
  }
}

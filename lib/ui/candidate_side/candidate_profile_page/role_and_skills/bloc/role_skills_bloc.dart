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
    });
  }
}

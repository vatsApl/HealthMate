abstract class RoleAndSkillsState {}

class ShowRoleAndSkillsInitialState extends RoleAndSkillsState {}

class ShowRoleAndSkillsLoadingState extends RoleAndSkillsState {}

class ShowRoleAndSkillsLoadedState extends RoleAndSkillsState {
  dynamic response;
  ShowRoleAndSkillsLoadedState(this.response);
}

class ShowRoleAndSkillsErrorState extends RoleAndSkillsState {
  final String error;
  ShowRoleAndSkillsErrorState({required this.error});
}

class UpdateRoleLoadingState extends RoleAndSkillsState {}

class UpdateRoleLoadedState extends RoleAndSkillsState {
  dynamic response;
  UpdateRoleLoadedState(this.response);
}

class UpdateRoleErrorState extends RoleAndSkillsState {
  final String error;
  UpdateRoleErrorState({required this.error});
}

class OnChangeSkillsLoadingState extends RoleAndSkillsState {}

class OnChangeSkillsLoadedState extends RoleAndSkillsState {
  dynamic response;
  OnChangeSkillsLoadedState(this.response);
}

class OnChangeSkillsErrorState extends RoleAndSkillsState {
  final String error;
  OnChangeSkillsErrorState({required this.error});
}

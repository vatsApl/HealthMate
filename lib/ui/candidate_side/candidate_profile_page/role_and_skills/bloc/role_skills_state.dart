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

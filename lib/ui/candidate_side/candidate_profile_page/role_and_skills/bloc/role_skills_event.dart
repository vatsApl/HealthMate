abstract class RoleAndSkillsEvent {}

class ShowRoleAndSkillsEvent extends RoleAndSkillsEvent {}

class UpdateRoleEvent extends RoleAndSkillsEvent {
  Map<String, dynamic> params;
  UpdateRoleEvent({required this.params});
}

class OnChangeSkillsEvent extends RoleAndSkillsEvent {
  int? selectedRoleIndexOnchangeSkills;
  OnChangeSkillsEvent({this.selectedRoleIndexOnchangeSkills});
}

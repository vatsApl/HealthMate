abstract class SignOffEvent {}

class UpdateTimesheetEvent extends SignOffEvent {
  int? timesheetId;
  late Map<String, dynamic> params;
  UpdateTimesheetEvent({this.timesheetId, required this.params});
}

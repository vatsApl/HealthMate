abstract class WorkedJobDescEvent {}

class ShowWorkedJobDescEvent extends WorkedJobDescEvent {
  int? jobId;
  ShowWorkedJobDescEvent({required this.jobId});
}

class EditTimesheetAfterDisputeEvent extends WorkedJobDescEvent {
  int? timesheetId;
  EditTimesheetAfterDisputeEvent({this.timesheetId});
}

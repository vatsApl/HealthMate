abstract class TimesheetDescEvent {}

class ShowTimesheetDescEvent extends TimesheetDescEvent {
  int? jobId;
  ShowTimesheetDescEvent({this.jobId});
}

class ApproveTimesheetEvent extends TimesheetDescEvent {
  int? timesheetId;
  ApproveTimesheetEvent({this.timesheetId});
}

class RejectTimesheetApi extends TimesheetDescEvent {
  Map<String, dynamic> params;
  RejectTimesheetApi({required this.params});
}

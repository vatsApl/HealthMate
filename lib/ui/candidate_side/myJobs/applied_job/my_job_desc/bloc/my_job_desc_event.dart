abstract class MyJobDescEvent {}

class ShowMyJobDescEvent extends MyJobDescEvent {
  int? jobId;
  ShowMyJobDescEvent({this.jobId});
}

// working on my job desc page of applied job & booked job(bloc pattern)
class WithdrawJobEvent extends MyJobDescEvent {
  int? appId;
  WithdrawJobEvent({this.appId});
}

class EditTimesheetEvent extends MyJobDescEvent {
  int? timesheetId;
  EditTimesheetEvent({this.timesheetId});
}

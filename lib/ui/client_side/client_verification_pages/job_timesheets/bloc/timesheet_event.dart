abstract class TimesheetEvent {}

class ShowTimesheetEvent extends TimesheetEvent {
  int pageValue;
  String status;
  ShowTimesheetEvent({
    required this.pageValue,
    required this.status,
  });
}

abstract class WorkedJobEvent {}

class ShowWorkedJobEvent extends WorkedJobEvent {
  int pageValue;
  ShowWorkedJobEvent({required this.pageValue});
}

class showAmountStatusEvent extends WorkedJobEvent {}

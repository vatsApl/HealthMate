abstract class AppliedJobEvent {}

class ShowAppliedJobEvent extends AppliedJobEvent {
  int? pageValue;
  ShowAppliedJobEvent({
    this.pageValue,
  });
}

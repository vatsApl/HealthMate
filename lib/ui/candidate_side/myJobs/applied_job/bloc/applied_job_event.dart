abstract class AppliedJobEvent {}

class ShowAppliedJobEvent extends AppliedJobEvent {
  int? pageValue;
  Map<String, dynamic> params;
  ShowAppliedJobEvent({this.pageValue, required this.params});
}

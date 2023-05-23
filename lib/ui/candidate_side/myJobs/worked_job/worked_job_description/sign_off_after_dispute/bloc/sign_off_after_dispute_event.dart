abstract class SignOffAfterDisputeEvent {}

class UpdateTimeSheetAfterDisputeEvent extends SignOffAfterDisputeEvent {
  Map<String, dynamic> params;
  UpdateTimeSheetAfterDisputeEvent({required this.params});
}

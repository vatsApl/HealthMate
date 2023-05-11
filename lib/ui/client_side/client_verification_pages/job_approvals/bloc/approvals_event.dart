abstract class ApprovalsEvent {}

class ShowApprovalsEvent extends ApprovalsEvent {
  int pageValue;
  String uId;
  String status;
  ShowApprovalsEvent({
    required this.pageValue,
    required this.uId,
    required this.status,
  });
}

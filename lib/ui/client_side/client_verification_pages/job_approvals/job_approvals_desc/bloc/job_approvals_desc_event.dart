abstract class JobApprovalsDescEvent {}

class ShowJobApprovalsDescEvent extends JobApprovalsDescEvent {
  int? jobId;
  ShowJobApprovalsDescEvent({this.jobId});
}

class ApproveApplicationEvent extends JobApprovalsDescEvent {
  int? candidateId;
  int? jobId;
  String? applicationId;
  ApproveApplicationEvent({
    this.candidateId,
    this.jobId,
    this.applicationId,
  });
}

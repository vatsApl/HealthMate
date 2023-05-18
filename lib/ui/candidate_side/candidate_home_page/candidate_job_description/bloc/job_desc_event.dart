abstract class JobDescEvent {}

class ShowJobDescEvent extends JobDescEvent {
  int? jobId;
  ShowJobDescEvent({required this.jobId});
}

class ApplyJobEvent extends JobDescEvent {
  Map<String, dynamic> params;
  ApplyJobEvent({required this.params});
}

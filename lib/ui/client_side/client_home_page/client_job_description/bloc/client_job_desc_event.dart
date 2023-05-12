abstract class ClientJobDescEvent {}

class ShowJobDescEvent extends ClientJobDescEvent {
  int? jobId;
  ShowJobDescEvent({this.jobId});
}

class RemoveContractEvent extends ClientJobDescEvent {
  int? jobId;
  RemoveContractEvent({this.jobId});
}

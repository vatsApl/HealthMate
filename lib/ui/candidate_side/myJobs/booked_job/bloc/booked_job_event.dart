abstract class BookedJobEvent {}

class ShowBookedJobEvent extends BookedJobEvent {
  int pageValue;
  ShowBookedJobEvent({required this.pageValue});
}

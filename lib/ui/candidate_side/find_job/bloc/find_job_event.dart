abstract class FindJobEvent {}

class ShowFindJobEvent extends FindJobEvent {
  int pageValue;
  ShowFindJobEvent({required this.pageValue});
}

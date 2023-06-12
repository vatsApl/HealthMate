// part of 'find_job_bloc.dart';

abstract class FindJobEvent {}

class ShowFindJobEvent extends FindJobEvent {
  int pageValue;
  ShowFindJobEvent({required this.pageValue});
}

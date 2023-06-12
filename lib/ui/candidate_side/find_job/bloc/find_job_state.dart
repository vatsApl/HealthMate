// part of 'find_job_bloc.dart';

abstract class FindJobState {}

class FindJobInitialState extends FindJobState {}

class FindJobLoadingState extends FindJobState {}

class FindJobLoadedState extends FindJobState {
  dynamic response;
  FindJobLoadedState(this.response);
}

class FindJobErrorState extends FindJobState {
  final String error;
  FindJobErrorState({required this.error});
}

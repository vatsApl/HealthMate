part of 'signup_candidate_bloc.dart';

abstract class SignupCandidateState {}

class SignupCandidateInitialState extends SignupCandidateState {}

class SignupCandidateLoadingState extends SignupCandidateState {}

class SignupCandidateLoadedState extends SignupCandidateState {
  dynamic response;
  SignupCandidateLoadedState(this.response);
}

class SignupCandidateErrorState extends SignupCandidateState {
  final String error;
  SignupCandidateErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

part of 'signup_candidate_bloc.dart';

abstract class SignupCandidateEvent {}

class SignupCandidateButtonPressed extends SignupCandidateEvent {
  Map<String, dynamic> params;
  SignupCandidateButtonPressed({
    required this.params,
  });
}

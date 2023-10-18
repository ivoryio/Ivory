import 'package:equatable/equatable.dart';

abstract class OnboardingEmailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingEmailInitialState extends OnboardingEmailState {}

class OnboardingEmailSubmittedState extends OnboardingEmailState {
  final String email;

  OnboardingEmailSubmittedState({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

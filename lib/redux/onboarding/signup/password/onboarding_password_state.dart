import 'package:equatable/equatable.dart';

abstract class OnboardingPasswordState extends Equatable {
  @override
  List<Object> get props => [];
}

class OnboardingPasswordInitialState extends OnboardingPasswordState {}

class OnboardingPasswordSubmittedState extends OnboardingPasswordState {
  final String password;

  OnboardingPasswordSubmittedState({
    required this.password,
  });

  @override
  List<Object> get props => [password];
}

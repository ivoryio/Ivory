import 'package:equatable/equatable.dart';

abstract class OnboardingBasicInfoState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingBasicInfoInitialState extends OnboardingBasicInfoState {}

class OnboardingBasicInfoSubmittedState extends OnboardingBasicInfoState {
  final String title;
  final String firstName;
  final String lastName;

  OnboardingBasicInfoSubmittedState({
    required this.title,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [title, firstName, lastName];
}

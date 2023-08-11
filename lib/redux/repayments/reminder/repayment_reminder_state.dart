import 'package:equatable/equatable.dart';

abstract class RepaymentReminderState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RepaymentReminderInitialState extends RepaymentReminderState {}

class RepaymentReminderLoadingState extends RepaymentReminderState {
  RepaymentReminderLoadingState();
}

class RepaymentReminderErrorState extends RepaymentReminderState {}

class RepaymentReminderFetchedState extends RepaymentReminderState {
  final List<DateTime> repaymentReminders;

  RepaymentReminderFetchedState(this.repaymentReminders);

  @override
  List<Object?> get props => [repaymentReminders];
}

import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/repayments/reminder/repayment_reminder.dart';

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
  final List<RepaymentReminder> repaymentReminders;

  RepaymentReminderFetchedState(this.repaymentReminders);

  @override
  List<Object?> get props => [repaymentReminders];
}

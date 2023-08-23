import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/repayments/reminder/repayment_reminder.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_state.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_state.dart';

class RepaymentReminderPresenter {
  static RepaymentReminderViewModel presentRepaymentReminder(
      {required RepaymentReminderState repaymentReminderState, required CreditLineState creditLineState}) {
    if (repaymentReminderState is RepaymentReminderLoadingState || creditLineState is CreditLineLoadingState) {
      return RepaymentReminderLoadingViewModel();
    } else if (repaymentReminderState is RepaymentReminderErrorState || creditLineState is CreditLineErrorState) {
      return RepaymentReminderErrorViewModel();
    } else if (repaymentReminderState is RepaymentReminderFetchedState && creditLineState is CreditLineFetchedState) {
      return RepaymentReminderFetchedViewModel(
        repaymentReminders: repaymentReminderState.repaymentReminders,
        repaymentDueDate: creditLineState.creditLine.dueDate,
      );
    }

    return RepaymentReminderInitialViewModel();
  }
}

abstract class RepaymentReminderViewModel extends Equatable {
  const RepaymentReminderViewModel();

  @override
  List<Object?> get props => [];
}

class RepaymentReminderInitialViewModel extends RepaymentReminderViewModel {}

class RepaymentReminderLoadingViewModel extends RepaymentReminderViewModel {}

class RepaymentReminderErrorViewModel extends RepaymentReminderViewModel {}

class RepaymentReminderFetchedViewModel extends RepaymentReminderViewModel {
  final List<RepaymentReminder> repaymentReminders;
  final DateTime repaymentDueDate;

  const RepaymentReminderFetchedViewModel({
    required this.repaymentReminders,
    required this.repaymentDueDate,
  });

  @override
  List<Object?> get props => [repaymentReminders, repaymentDueDate];
}

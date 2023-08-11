import 'repayment_reminder_action.dart';
import 'repayment_reminder_state.dart';

RepaymentReminderState repaymentReminderReducer(RepaymentReminderState currentState, dynamic action) {
  if (action is RepaymentReminderLoadingEventAction) {
    return RepaymentReminderLoadingState();
  } else if (action is RepaymentReminderFailedEventAction) {
    return RepaymentReminderErrorState();
  } else if (action is RepaymentReminderFetchedEventAction) {
    return RepaymentReminderFetchedState(action.repaymentReminders);
  }

  return currentState;
}

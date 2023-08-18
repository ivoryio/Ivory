import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/repayments/reminder/repayment_reminder_service.dart';
import 'package:solarisdemo/models/repayments/reminder/repayment_reminder.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_action.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_state.dart';

class RepaymentRemindersMiddleware extends MiddlewareClass<AppState> {
  final RepaymentReminderService _repaymentReminderService;

  RepaymentRemindersMiddleware(this._repaymentReminderService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is GetRepaymentRemindersCommandAction) {
      store.dispatch(RepaymentReminderLoadingEventAction());
      final response = await _repaymentReminderService.getRepaymentReminders(user: action.user);

      if (response is GetRepaymentReminderSuccessResponse) {
        store.dispatch(RepaymentReminderFetchedEventAction(repaymentReminders: response.repaymentReminders));
      } else {
        store.dispatch(RepaymentReminderFailedEventAction());
      }
    } else if (action is UpdateRepaymentRemindersCommandAction) {
      final response = await _repaymentReminderService.batchAddRepaymentReminders(reminders: action.reminders);
      final currentReminders = store.state.repaymentReminderState is RepaymentReminderFetchedState
          ? (store.state.repaymentReminderState as RepaymentReminderFetchedState).repaymentReminders
          : List<RepaymentReminder>.empty();

      if (response is BatchAddRepaymentReminderSuccessResponse) {
        store.dispatch(RepaymentReminderFetchedEventAction(
          repaymentReminders: currentReminders..addAll(response.repaymentReminders),
        ));
      } else {
        store.dispatch(RepaymentReminderFailedEventAction());
      }
    } else if (action is DeleteRepaymentReminderCommandAction) {
      final response = await _repaymentReminderService.deleteRepaymentReminder(reminder: action.reminder);
      final currentReminders = store.state.repaymentReminderState is RepaymentReminderFetchedState
          ? (store.state.repaymentReminderState as RepaymentReminderFetchedState).repaymentReminders
          : List<RepaymentReminder>.empty();

      if (response is DeleteRepaymentReminderSuccessResponse) {
        store.dispatch(RepaymentReminderFetchedEventAction(
          repaymentReminders: currentReminders..remove(action.reminder),
        ));
      } else {
        store.dispatch(RepaymentReminderFailedEventAction());
      }
    }
  }
}

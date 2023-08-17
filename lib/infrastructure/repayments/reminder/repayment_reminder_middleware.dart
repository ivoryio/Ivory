import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/repayments/reminder/repayment_reminder_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_action.dart';

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

      if (response is BatchAddRepaymentReminderSuccessResponse) {
      } else {
        store.dispatch(RepaymentReminderFailedEventAction());
      }
    } else if (action is DeleteRepaymentReminderCommandAction) {
      final response = await _repaymentReminderService.deleteRepaymentReminder(reminder: action.reminder);

      if (response is DeleteRepaymentReminderSuccessResponse) {
      } else {
        store.dispatch(RepaymentReminderFailedEventAction());
      }
    }
  }
}

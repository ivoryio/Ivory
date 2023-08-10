import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/repayments/reminder/repayment_reminder_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_action.dart';

class GetRepaymentRemindersMiddleware extends MiddlewareClass<AppState> {
  final RepaymentReminderService _repaymentReminderService;

  GetRepaymentRemindersMiddleware(this._repaymentReminderService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is GetRepaymentRemindersCommandAction) {
      store.dispatch(RepaymentReminderLoadingEventAction());
      final response = await _repaymentReminderService.getRepaymentReminders(user: action.user);

      if (response is RepaymentReminderSuccessResponse) {
        store.dispatch(RepaymentReminderFetchedEventAction(repaymentReminders: response.repaymentReminders));
      } else {
        store.dispatch(RepaymentReminderFailedEventAction());
      }
    }
  }
}

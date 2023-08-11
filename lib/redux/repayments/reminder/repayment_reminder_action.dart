import 'package:solarisdemo/models/user.dart';

class GetRepaymentRemindersCommandAction {
  final User user;
  GetRepaymentRemindersCommandAction({required this.user});
}

class UpdateRepaymentRemindersCommandAction {
  final List<DateTime> reminders;
  UpdateRepaymentRemindersCommandAction({required this.reminders});
}

class RepaymentReminderLoadingEventAction {}

class RepaymentReminderFailedEventAction {}

class RepaymentReminderFetchedEventAction {
  final List<DateTime> repaymentReminders;
  RepaymentReminderFetchedEventAction({required this.repaymentReminders});
}

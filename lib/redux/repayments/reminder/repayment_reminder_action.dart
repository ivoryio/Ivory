import 'package:solarisdemo/models/repayments/reminder/repayment_reminder.dart';
import 'package:solarisdemo/models/user.dart';

class GetRepaymentRemindersCommandAction {
  final User user;

  GetRepaymentRemindersCommandAction({required this.user});
}

class UpdateRepaymentRemindersCommandAction {
  final List<RepaymentReminder> reminders;

  UpdateRepaymentRemindersCommandAction({required this.reminders});
}

class DeleteRepaymentReminderCommandAction {
  final RepaymentReminder reminder;

  DeleteRepaymentReminderCommandAction({required this.reminder});
}

class RepaymentReminderLoadingEventAction {}

class RepaymentReminderFailedEventAction {}

class RepaymentReminderFetchedEventAction {
  final List<RepaymentReminder> repaymentReminders;

  RepaymentReminderFetchedEventAction({required this.repaymentReminders});
}

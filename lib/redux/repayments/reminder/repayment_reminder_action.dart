import 'package:solarisdemo/models/repayments/reminder/repayment_reminder.dart';

class GetRepaymentRemindersCommandAction {}

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

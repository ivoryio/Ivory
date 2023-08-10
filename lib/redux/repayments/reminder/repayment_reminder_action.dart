import 'package:solarisdemo/models/user.dart';

class GetRepaymentRemindersCommandAction {
  final User user;
  GetRepaymentRemindersCommandAction({required this.user});
}

class RepaymentReminderLoadingEventAction {}

class RepaymentReminderFailedEventAction {}

class RepaymentReminderFetchedEventAction {
  final List<DateTime> repaymentReminders;
  RepaymentReminderFetchedEventAction({required this.repaymentReminders});
}

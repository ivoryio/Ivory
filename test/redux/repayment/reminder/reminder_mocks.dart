import 'package:solarisdemo/infrastructure/repayments/reminder/repayment_reminder_service.dart';
import 'package:solarisdemo/models/repayments/reminder/repayment_reminder.dart';
import 'package:solarisdemo/models/user.dart';

class FakeRepaymentReminderService extends RepaymentReminderService {
  @override
  Future<RepaymentReminderServiceResponse> getRepaymentReminders({
    User? user,
  }) async {
    return GetRepaymentReminderSuccessResponse(repaymentReminders: [
      RepaymentReminder(
        id: "1",
        datetime: DateTime.now(),
        description: "Test",
      ),
    ]);
  }

  @override
  Future<RepaymentReminderServiceResponse> batchAddRepaymentReminders({
    User? user,
    required List<RepaymentReminder> reminders,
  }) async {
    return BatchAddRepaymentReminderSuccessResponse(
      repaymentReminders: [
        RepaymentReminder(
          id: "1",
          datetime: DateTime.now(),
          description: "Test",
        )
      ],
    );
  }

  @override
  Future<RepaymentReminderServiceResponse> deleteRepaymentReminder({
    User? user,
    required RepaymentReminder reminder,
  }) async {
    return DeleteRepaymentReminderSuccessResponse();
  }
}

class FakeFailingRepaymentReminderService extends RepaymentReminderService {
  @override
  Future<RepaymentReminderServiceResponse> getRepaymentReminders({
    User? user,
  }) async {
    return RepaymentReminderServiceErrorResponse();
  }

  @override
  Future<RepaymentReminderServiceResponse> batchAddRepaymentReminders({
    User? user,
    required List<RepaymentReminder> reminders,
  }) async {
    return RepaymentReminderServiceErrorResponse();
  }

  @override
  Future<RepaymentReminderServiceResponse> deleteRepaymentReminder({
    User? user,
    required RepaymentReminder reminder,
  }) async {
    return RepaymentReminderServiceErrorResponse();
  }
}

import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/repayments/reminder/repayment_reminder.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class RepaymentReminderService extends ApiService {
  RepaymentReminderService({super.user});

  Future<RepaymentReminderServiceResponse> getRepaymentReminders({
    User? user,
  }) async {
    if (user != null) {
      this.user = user;
    }
    try {
      final data = await get('notifications/scheduled');
      final reminders = (data as List).map<RepaymentReminder>((e) {
        return RepaymentReminder(
          id: e["id"] as String,
          datetime: DateTime.parse(e["datetime"] as String),
          description: e["details"]["description"] as String,
        );
      }).toList();

      return GetRepaymentReminderSuccessResponse(repaymentReminders: reminders);
    } catch (e) {
      return GetRepaymentReminderSuccessResponse(repaymentReminders: const []);
    }
  }

  Future<RepaymentReminderServiceResponse> addRepaymentReminder({
    User? user,
    required RepaymentReminder reminder,
  }) async {
    if (user != null) {
      this.user = user;
    }

    try {
      final datetime = "${reminder.datetime.toIso8601String().replaceAll("Z", "")}Z"; // TODO: Fix this hack
      final data = await post('notifications/scheduled', body: {
        "datetime": datetime,
        "title": "Repayment Reminder",
        "body": "You have a repayment due on $datetime",
        "type": "REPAYMENT_REMINDER",
        "details": {
          "description": reminder.description,
        }
      });

      return AddRepaymentReminderSuccessResponse(
        repaymentReminder: RepaymentReminder(
          id: data["id"] as String,
          datetime: DateTime.parse(data["datetime"] as String),
          description: data["details"]["description"] as String,
        ),
      );
    } catch (e) {
      return RepaymentReminderServiceErrorResponse();
    }
  }

  Future<RepaymentReminderServiceResponse> batchAddRepaymentReminders({
    User? user,
    required List<RepaymentReminder> reminders,
  }) async {
    if (user != null) {
      this.user = user;
    }

    try {
      final addedReminders = <RepaymentReminder>[];

      for (final reminder in reminders) {
        final data = await addRepaymentReminder(reminder: reminder);

        if (data is AddRepaymentReminderSuccessResponse) {
          addedReminders.add(data.repaymentReminder);
        }
      }

      return BatchAddRepaymentReminderSuccessResponse();
    } catch (e) {
      return RepaymentReminderServiceErrorResponse();
    }
  }

  Future<RepaymentReminderServiceResponse> deleteRepaymentReminder({
    User? user,
    required RepaymentReminder reminder,
  }) async {
    if (user != null) {
      this.user = user;
    }

    try {
      await delete('notifications/scheduled/${reminder.id}');

      return DeleteRepaymentReminderSuccessResponse();
    } catch (e) {
      return RepaymentReminderServiceErrorResponse();
    }
  }
}

abstract class RepaymentReminderServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetRepaymentReminderSuccessResponse extends RepaymentReminderServiceResponse {
  final List<RepaymentReminder> repaymentReminders;

  GetRepaymentReminderSuccessResponse({required this.repaymentReminders});

  @override
  List<Object?> get props => [repaymentReminders];
}

class AddRepaymentReminderSuccessResponse extends RepaymentReminderServiceResponse {
  final RepaymentReminder repaymentReminder;

  AddRepaymentReminderSuccessResponse({required this.repaymentReminder});

  @override
  List<Object?> get props => [repaymentReminder];
}

class BatchAddRepaymentReminderSuccessResponse extends RepaymentReminderServiceResponse {}

class DeleteRepaymentReminderSuccessResponse extends RepaymentReminderServiceResponse {}

class RepaymentReminderServiceErrorResponse extends RepaymentReminderServiceResponse {}

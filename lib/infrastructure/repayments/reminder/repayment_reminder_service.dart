import 'package:equatable/equatable.dart';
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
      final data = await get('repayments/reminders');
      final reminders = (data as List).map<DateTime>((e) => DateTime.parse(e)).toList();

      return RepaymentReminderSuccessResponse(repaymentReminders: reminders);
    } catch (e) {
      return RepaymentReminderSuccessResponse(repaymentReminders: const []);
      return RepaymentReminderServiceErrorResponse();
    }
  }
}

abstract class RepaymentReminderServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class RepaymentReminderSuccessResponse extends RepaymentReminderServiceResponse {
  final List<DateTime> repaymentReminders;

  RepaymentReminderSuccessResponse({required this.repaymentReminders});

  @override
  List<Object?> get props => [repaymentReminders];
}

class RepaymentReminderServiceErrorResponse extends RepaymentReminderServiceResponse {}

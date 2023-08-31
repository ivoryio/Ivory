import 'package:solarisdemo/models/user.dart';

class TransactionApprovalRequestChallengeCommandAction {
  final User user;
  final String changeRequestId;
  final String deviceId;
  final String deviceData;

  TransactionApprovalRequestChallengeCommandAction({
    required this.user,
    required this.changeRequestId,
    required this.deviceId,
    required this.deviceData,
  });
}

class TransactionApprovalChallengeFetchedEventAction {
  final String changeRequestId;
  final String stringToSign;

  TransactionApprovalChallengeFetchedEventAction({
    required this.changeRequestId,
    required this.stringToSign,
  });
}

class TransactionApprovalSucceededEventAction {}

class TransactionApprovalFailedEventAction {}

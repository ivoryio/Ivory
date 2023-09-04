import 'package:solarisdemo/models/user.dart';

class AuthorizeTransactionApprovalChallengeCommandAction {
  final User user;
  final String changeRequestId;

  AuthorizeTransactionApprovalChallengeCommandAction({
    required this.user,
    required this.changeRequestId,
  });
}

class TransactionApprovalChallengeAuthorizedEventAction {
  final String deviceId;
  final String deviceData;
  final String stringToSign;
  final String changeRequestId;

  TransactionApprovalChallengeAuthorizedEventAction({
    required this.deviceId,
    required this.deviceData,
    required this.stringToSign,
    required this.changeRequestId,
  });
}

class ConfirmTransactionApprovalChallengeCommandAction {
  final User user;
  final String deviceId;
  final String deviceData;
  final String stringToSign;
  final String changeRequestId;

  ConfirmTransactionApprovalChallengeCommandAction({
    required this.user,
    required this.deviceId,
    required this.deviceData,
    required this.stringToSign,
    required this.changeRequestId,
  });
}

class TransactionApprovalSucceededEventAction {}

class TransactionApprovalFailedEventAction {}

class TransactionApprovalDeviceNotBoundedEventAction {}

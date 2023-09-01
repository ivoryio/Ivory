import 'package:solarisdemo/models/user.dart';

class RequestTransactionApprovalChallengeCommandAction {
  final User user;
  final String changeRequestId;

  RequestTransactionApprovalChallengeCommandAction({
    required this.user,
    required this.changeRequestId,
  });
}

class ConfirmTransactionApprovalChallengeCommandAction {
  final String changeRequestId;
  final String signature;

  ConfirmTransactionApprovalChallengeCommandAction({
    required this.changeRequestId,
    required this.signature,
  });
}

class TransactionApprovalChallengeFetchedEventAction {
  final String changeRequestId;
  final String stringToSign;
  final String deviceId;
  final String deviceData;

  TransactionApprovalChallengeFetchedEventAction({
    required this.changeRequestId,
    required this.stringToSign,
    required this.deviceId,
    required this.deviceData,
  });
}

class TransactionApprovalSucceededEventAction {}

class TransactionApprovalFailedEventAction {}

class TransactionApprovalDeviceNotBoundedEventAction {}

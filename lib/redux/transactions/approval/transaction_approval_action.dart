import 'package:solarisdemo/models/user.dart';

class RequestTransactionApprovalChallengeCommandAction {
  final User user;
  final String changeRequestId;

  RequestTransactionApprovalChallengeCommandAction({
    required this.user,
    required this.changeRequestId,
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

class TransactionApprovalDeviceNotBoundedEventAction {}

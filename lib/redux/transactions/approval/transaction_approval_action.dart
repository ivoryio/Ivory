import 'package:solarisdemo/models/user.dart';

class AuthorizeTransactionCommandAction {
  final User user;
  final String changeRequestId;

  AuthorizeTransactionCommandAction({
    required this.user,
    required this.changeRequestId,
  });
}

class AuthorizedTransactionEventAction {
  final String deviceId;
  final String deviceData;
  final String stringToSign;
  final String changeRequestId;

  AuthorizedTransactionEventAction({
    required this.deviceId,
    required this.deviceData,
    required this.stringToSign,
    required this.changeRequestId,
  });
}

class ConfirmTransactionCommandAction {
  final User user;
  final String deviceId;
  final String deviceData;
  final String stringToSign;
  final String changeRequestId;

  ConfirmTransactionCommandAction({
    required this.user,
    required this.deviceId,
    required this.deviceData,
    required this.stringToSign,
    required this.changeRequestId,
  });
}

class RejectTransactionCommandAction {
  final User user;
  final String deviceId;
  final String deviceData;
  final String stringToSign;
  final String declineChangeRequestId;

  RejectTransactionCommandAction({
    required this.user,
    required this.deviceId,
    required this.deviceData,
    required this.stringToSign,
    required this.declineChangeRequestId,
  });
}

class TransactionConfirmedEventAction {}

class TransactionRejectedEventAction {}

class TransactionApprovalFailedEventAction {}

class TransactionApprovalDeviceNotBoundedEventAction {}

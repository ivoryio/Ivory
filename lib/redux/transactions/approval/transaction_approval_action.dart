class AuthorizeTransactionCommandAction {
  final String changeRequestId;

  AuthorizeTransactionCommandAction({
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
  final String deviceId;
  final String deviceData;
  final String stringToSign;
  final String changeRequestId;

  ConfirmTransactionCommandAction({
    required this.deviceId,
    required this.deviceData,
    required this.stringToSign,
    required this.changeRequestId,
  });
}

class RejectTransactionCommandAction {
  final String deviceId;
  final String deviceData;
  final String stringToSign;
  final String declineChangeRequestId;

  RejectTransactionCommandAction({
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

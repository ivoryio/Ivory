import 'package:solarisdemo/models/transfer/reference_account_transfer.dart';
import 'package:solarisdemo/models/user.dart';

class TransferCommandAction {
  final User user;
  final ReferenceAccountTransfer transfer;

  TransferCommandAction({required this.user, required this.transfer});
}

class ConfirmTransferCommandAction {
  final User user;
  final String changeRequestId;
  final String tan;

  ConfirmTransferCommandAction({
    required this.user,
    required this.changeRequestId,
    required this.tan,
  });
}

class SendTransferSuccessEventAction {}

class SendTransferFailedEventAction {}

class ConfirmTransferSuccessEventAction {}

class ConfirmTransferFailedEventAction {}

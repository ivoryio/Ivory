import 'package:solarisdemo/models/transfer/reference_account_transfer.dart';
import 'package:solarisdemo/models/transfer/transfer_authorization_request.dart';
import 'package:solarisdemo/models/user.dart';

import '../../models/change_request/change_request_error_type.dart';

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

class SendTransferSuccessEventAction {
  final TransferAuthorizationRequest transferAuthorizationRequest;

  SendTransferSuccessEventAction({required this.transferAuthorizationRequest});
}

class SendTransferFailedEventAction {}

class ConfirmTransferSuccessEventAction {
  final ReferenceAccountTransfer transfer;

  ConfirmTransferSuccessEventAction({required this.transfer});
}

class ConfirmTransferFailedEventAction {
  final ChangeRequestErrorType errorType;

  ConfirmTransferFailedEventAction(this.errorType);
}

import 'package:solarisdemo/infrastructure/change_request/change_request_service.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_service.dart';
import 'package:solarisdemo/models/transfer/reference_account_transfer.dart';
import 'package:solarisdemo/models/user.dart';

class FakeTransferService extends TransferService {
  @override
  Future<TransferServiceResponse> createPayoutTransfer({
    User? user,
    required ReferenceAccountTransfer transfer,
  }) async {
    return CreatePayoutTransferSuccessResponse();
  }
}

class FakeFailingTransferService extends TransferService {
  @override
  Future<TransferServiceResponse> createPayoutTransfer({
    User? user,
    required ReferenceAccountTransfer transfer,
  }) async {
    return TransferServiceErrorResponse();
  }
}

class FakeChangeRequestService extends ChangeRequestService {
  @override
  Future<ChangeRequestServiceResponse> confirmChangeRequest({
    User? user,
    required String changeRequestId,
    required String tan,
  }) async {
    return ChangeRequestConfirmSuccessResponse();
  }
}

class FakeFailingChangeRequestService extends ChangeRequestService {
  @override
  Future<ChangeRequestServiceResponse> confirmChangeRequest({
    User? user,
    required String changeRequestId,
    required String tan,
  }) async {
    return ChangeRequestConfirmErrorResponse();
  }
}

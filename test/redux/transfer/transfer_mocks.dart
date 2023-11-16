import 'package:solarisdemo/infrastructure/change_request/change_request_service.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_service.dart';
import 'package:solarisdemo/models/transfer/reference_account_transfer.dart';
import 'package:solarisdemo/models/transfer/transfer_authorization_request.dart';
import 'package:solarisdemo/models/transfer/transfer_confirmation.dart';
import 'package:solarisdemo/models/user.dart';

class FakeTransferService extends TransferService {
  @override
  Future<TransferServiceResponse> createPayoutTransfer({
    User? user,
    required ReferenceAccountTransfer transfer,
  }) async {
    return const CreatePayoutTransferSuccessResponse(
      transferAuthorizationRequest: TransferAuthorizationRequest(
        id: '31e02b4d5fc5304adb72fa496ee5c777csc',
        status: 'CONFIRMATION_REQUIRED',
        confirmUrl: '/change_requests/31e02b4d5fc5304adb72fa496ee5c777csc/confirm',
        stringToSign: null,
      ),
    );
  }
}

class FakeFailingTransferService extends TransferService {
  @override
  Future<TransferServiceResponse> createPayoutTransfer({
    User? user,
    required ReferenceAccountTransfer transfer,
  }) async {
    return const TransferServiceErrorResponse();
  }
}

class FakeChangeRequestService extends ChangeRequestService {
  @override
  Future<ChangeRequestServiceResponse> confirmTransferChangeRequest({
    User? user,
    required String changeRequestId,
    required String tan,
  }) async {
    return ConfirmTransferChangeRequestSuccessResponse(
      transferConfirmation: const TransferConfirmation(
        success: true,
        transfer: ReferenceAccountTransfer(
          description: 'transfer description',
          amount: ReferenceAccountTransferAmount(
            value: 100,
          ),
        ),
      ),
    );
  }
}

class FakeFailingChangeRequestService extends ChangeRequestService {
  @override
  Future<ChangeRequestServiceResponse> confirmTransferChangeRequest({
    User? user,
    required String changeRequestId,
    required String tan,
  }) async {
    return ChangeRequestServiceErrorResponse();
  }
}

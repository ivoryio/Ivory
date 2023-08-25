import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/currency/currency.dart';
import 'package:solarisdemo/models/transfer/reference_account_transfer.dart';
import 'package:solarisdemo/models/transfer/transfer_authorization_request.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

const _noDescriptionProvidedText = "-";

class TransferService extends ApiService {
  TransferService({super.user});

  Future<TransferServiceResponse> createPayoutTransfer({
    User? user,
    required ReferenceAccountTransfer transfer,
  }) async {
    if (user != null) {
      this.user = user;
    }

    try {
      var data = await post(
        '/transactions/reference_account_payouts',
        body: {
          "description": transfer.description.isNotEmpty
              ? transfer.description
              : _noDescriptionProvidedText,
          "amount": {
            "value": transfer.amount.value,
            "currency": transfer.amount.currency.nameString,
          },
        },
      );

      return CreatePayoutTransferSuccessResponse(
        transferAuthorizationRequest: TransferAuthorizationRequest(
          id: data['authorizationRequest']['id'] as String,
          status: data['authorizationRequest']['status'],
          confirmUrl: data['confirmUrl'],
          stringToSign: data['authorizationRequest']['string_to_sign'],
        ),
      );
    } catch (e) {
      return TransferServiceErrorResponse();
    }
  }
}

abstract class TransferServiceResponse extends Equatable {
  const TransferServiceResponse();

  @override
  List<Object> get props => [];
}

class CreatePayoutTransferSuccessResponse extends TransferServiceResponse {
  final TransferAuthorizationRequest transferAuthorizationRequest;

  const CreatePayoutTransferSuccessResponse({
    required this.transferAuthorizationRequest,
  });

  @override
  List<Object> get props => [transferAuthorizationRequest];
}

class TransferServiceErrorResponse extends TransferServiceResponse {}

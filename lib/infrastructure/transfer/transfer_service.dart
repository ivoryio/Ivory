import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/transfer/reference_account_transfer.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

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
          "description": transfer.description,
          "amount": {
            "value": transfer.amount.value,
            "currency": transfer.amount.currency.name,
          },
        },
      );

      return CreatePayoutTransferSuccessResponse();
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

class CreatePayoutTransferSuccessResponse extends TransferServiceResponse {}

class TransferServiceErrorResponse extends TransferServiceResponse {}

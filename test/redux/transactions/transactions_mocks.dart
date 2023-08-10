import 'package:solarisdemo/infrastructure/transactions/transaction_service.dart';
import 'package:solarisdemo/models/transaction_model.dart';
import 'package:solarisdemo/models/user.dart';

class FakeTransactionService extends TransactionService {
  @override
  Future<TransactionsServiceResponse> getTransactions({
    TransactionListFilter? filter, User? user,
  }) async {
    return GetTransactionsSuccessResponse(transactions: [
      Transaction(
        id: "6e40fbd5-d7fa-5656-bff8-e19a8f4fa540",
        bookingType: "SEPA_CREDIT_TRANSFER",
        amount: Amount(
          currency: "EUR",
          unit: "cents",
          value: -100
        ),
        description: "test transfer",
        senderIban: "DE60110101014274796688",
        senderName: "THINSLICES MAIN",
        recipientName: "Ionut",
        recordedAt: DateTime.parse("2023-07-05T09:06:02Z"),
      ),
      Transaction(
        id: "6e40fbd5-d7fa-5656-bff8-e19a8f4fa540",
        bookingType: "INTERNAL_TRANSFER",
        amount: Amount(
            currency: "EUR",
            unit: "cents",
            value: -100
        ),
        description: "Top up from Omega to Alpha",
        senderIban: "DE60110101014274796688",
        senderName: "THINSLICES MAIN",
        recipientName: "Ionut",
        recordedAt: DateTime.parse("2023-07-05T09:06:02Z"),
      ),
    ],);
  }
}

class FakeFailingTransactionService extends TransactionService {
  @override
  Future<TransactionsServiceResponse> getTransactions({
    TransactionListFilter? filter,
    User? user
  }) async {
    return TransactionsServiceErrorResponse();
  }
}
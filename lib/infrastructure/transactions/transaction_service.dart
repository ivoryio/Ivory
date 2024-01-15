import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/amount_value.dart';

import '../../models/transactions/transaction_model.dart';
import '../../models/transactions/upcoming_transaction_model.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';

class TransactionService extends ApiService {
  TransactionService({super.user});

  Future<TransactionsServiceResponse> getTransactions({
    TransactionListFilter? filter,
    required User user,
  }) async {
    this.user = user;

    try {
      // var data = await get(
      //   '/transactions',
      //   queryParameters: filter?.toMap() ?? {},
      // );

      // List<Transaction> transactions = (data as List).map((transaction) => Transaction.fromJson(transaction)).toList();

      final data = [
        {
          "id": "178929812",
          "linkId": "178929712",
          "transactionDate": "2024-01-15T13:18:36",
          "postingDate": "2024-01-15T00:00:00",
          "postingStatus": "POSTED",
          "responseCode": "0",
          "transactionType": {"authorizationType": "FINANCIAL", "code": "A2AD"},
          "transactionConditionCode": null,
          "retrievalReferenceNumber": null,
          "authorizationCode": null,
          "acquiringInstitutionIdentificationCode": null,
          "cardAcceptorIdentificationCode": null,
          "settlementAmount": {"amount": "-445.00", "currency": "EUR"},
          "transactionAmount": {"amount": "-445.00", "currency": "EUR"},
          "feeAmount": {"amount": "0.00", "currency": null},
          "merchant": {"country": null, "city": null, "name": "Amazon.com, Inc.", "mcc": null},
          "text": "im another text",
          "createdAt": "2024-01-15T13:18:36",
          "cardId": null
        },
        {
          "id": "178929712",
          "linkId": "178929712",
          "transactionDate": "2024-01-15T13:18:35",
          "postingDate": "2024-01-15T00:00:00",
          "postingStatus": "CLOSED",
          "responseCode": "0",
          "transactionType": {"authorizationType": "AUTH", "code": "A2AD"},
          "transactionConditionCode": null,
          "retrievalReferenceNumber": null,
          "authorizationCode": "440514",
          "acquiringInstitutionIdentificationCode": null,
          "cardAcceptorIdentificationCode": null,
          "settlementAmount": {"amount": "-445.00", "currency": "EUR"},
          "transactionAmount": {"amount": "-445.00", "currency": "EUR"},
          "feeAmount": {"amount": "0.00", "currency": null},
          "merchant": {"country": null, "city": null, "name": "Amazon.com, Inc.", "mcc": null},
          "text": null,
          "createdAt": "2024-01-15T13:18:35",
          "cardId": null
        },
        {
          "id": "178324512",
          "linkId": "178324412",
          "transactionDate": "2024-01-11T13:37:16",
          "postingDate": "2024-01-11T00:00:00",
          "postingStatus": "POSTED",
          "responseCode": "0",
          "transactionType": {"authorizationType": "FINANCIAL", "code": "A2AD"},
          "transactionConditionCode": null,
          "retrievalReferenceNumber": null,
          "authorizationCode": null,
          "acquiringInstitutionIdentificationCode": null,
          "cardAcceptorIdentificationCode": null,
          "settlementAmount": {"amount": "-321.00", "currency": "EUR"},
          "transactionAmount": {"amount": "-321.00", "currency": "EUR"},
          "feeAmount": {"amount": "0.00", "currency": null},
          "merchant": {"country": null, "city": null, "name": "Uber", "mcc": null},
          "text": "test",
          "createdAt": "2024-01-11T13:37:16",
          "cardId": null
        },
        {
          "id": "178324412",
          "linkId": "178324412",
          "transactionDate": "2024-01-11T13:37:16",
          "postingDate": "2024-01-11T00:00:00",
          "postingStatus": "CLOSED",
          "responseCode": "0",
          "transactionType": {"authorizationType": "AUTH", "code": "A2AD"},
          "transactionConditionCode": null,
          "retrievalReferenceNumber": null,
          "authorizationCode": "440513",
          "acquiringInstitutionIdentificationCode": null,
          "cardAcceptorIdentificationCode": null,
          "settlementAmount": {"amount": "-321.00", "currency": "EUR"},
          "transactionAmount": {"amount": "-321.00", "currency": "EUR"},
          "feeAmount": {"amount": "0.00", "currency": null},
          "merchant": {"country": null, "city": null, "name": "Uber", "mcc": null},
          "text": null,
          "createdAt": "2024-01-11T13:37:16",
          "cardId": null
        },
        {
          "id": "178322712",
          "linkId": "178322612",
          "transactionDate": "2024-01-11T13:17:43",
          "postingDate": "2024-01-11T00:00:00",
          "postingStatus": "POSTED",
          "responseCode": "0",
          "transactionType": {"authorizationType": "FINANCIAL", "code": "C2CC"},
          "transactionConditionCode": null,
          "retrievalReferenceNumber": null,
          "authorizationCode": null,
          "acquiringInstitutionIdentificationCode": null,
          "cardAcceptorIdentificationCode": null,
          "settlementAmount": {"amount": "120.00", "currency": "EUR"},
          "transactionAmount": {"amount": "120.00", "currency": "EUR"},
          "feeAmount": {"amount": "0.00", "currency": null},
          "merchant": {"country": null, "city": null, "name": "Peter Petty", "mcc": null},
          "text": null,
          "createdAt": "2024-01-11T13:17:43",
          "cardId": null
        },
        {
          "id": "178322612",
          "linkId": "178322612",
          "transactionDate": "2024-01-11T13:17:42",
          "postingDate": "2024-01-11T00:00:00",
          "postingStatus": "CLOSED",
          "responseCode": "0",
          "transactionType": {"authorizationType": "AUTH", "code": "C2CC"},
          "transactionConditionCode": null,
          "retrievalReferenceNumber": null,
          "authorizationCode": "440512",
          "acquiringInstitutionIdentificationCode": null,
          "cardAcceptorIdentificationCode": null,
          "settlementAmount": {"amount": "120.00", "currency": "EUR"},
          "transactionAmount": {"amount": "120.00", "currency": "EUR"},
          "feeAmount": {"amount": "0.00", "currency": null},
          "merchant": {"country": null, "city": null, "name": "Peter Petty", "mcc": null},
          "text": null,
          "createdAt": "2024-01-11T13:17:42",
          "cardId": null
        }
      ] as dynamic;

      List<Transaction> transactions = (data as List)
          .where((transaction) => transaction['postingStatus'] == 'POSTED')
          .map(
            (transaction) => Transaction(
              id: transaction['id'],
              bookingType: 'asd',
              amount: AmountValue(
                value: double.parse(transaction['transactionAmount']['amount']),
                unit: "cents",
                currency: "EUR",
              ),
              description: transaction['text'],
              bookingDate: transaction['postingDate'],
              recordedAt: DateTime.parse(
                transaction['createdAt'],
              ),
              recipientName: transaction['merchant']['name'],
            ),
          )
          .toList();

      return GetTransactionsSuccessResponse(transactions: transactions);
    } catch (e) {
      return TransactionsServiceErrorResponse();
    }
  }

  Future<UpcomingTransactionServiceResponse> getUpcomingTransactions({
    required User user,
  }) async {
    this.user = user;
    try {
      var data = await get('/bills/upcoming_bills');

      List<UpcomingTransaction> upcomingTransactions =
          (data as List).map((transaction) => UpcomingTransaction.fromJson(transaction)).toList();

      upcomingTransactions.addAll({
        UpcomingTransaction(
          statementDate: DateTime.now(),
          dueDate: DateTime.now(),
          outstandingAmount: AmountValue(value: 496.22, unit: "cents", currency: "EUR"),
        ),
        UpcomingTransaction(
          statementDate: DateTime.now().add(const Duration(days: 7)),
          dueDate: DateTime.now().add(const Duration(days: 7)),
          outstandingAmount: AmountValue(value: 123.45, unit: "cents", currency: "EUR"),
        ),
      });

      return GetUpcomingTransactionsSuccessResponse(upcomingTransactions: upcomingTransactions);
    } catch (e) {
      return UpcomingTransactionsServiceErrorResponse();
    }
  }
}

abstract class TransactionsServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetTransactionsSuccessResponse extends TransactionsServiceResponse {
  final List<Transaction> transactions;

  GetTransactionsSuccessResponse({required this.transactions});

  @override
  List<Object?> get props => [transactions];
}

class TransactionsServiceErrorResponse extends TransactionsServiceResponse {}

abstract class UpcomingTransactionServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetUpcomingTransactionsSuccessResponse extends UpcomingTransactionServiceResponse {
  final List<UpcomingTransaction> upcomingTransactions;

  GetUpcomingTransactionsSuccessResponse({required this.upcomingTransactions});

  @override
  List<Object?> get props => [upcomingTransactions];
}

class UpcomingTransactionsServiceErrorResponse extends UpcomingTransactionServiceResponse {}

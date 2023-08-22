import 'dart:developer';

import 'package:equatable/equatable.dart';

import '../../models/upcoming_transactions.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import '../../models/transfer.dart';
import '../../models/transactions/transaction_model.dart';
import '../../models/authorization_request.dart';

class TransactionService extends ApiService {
  TransactionService({super.user});

  Future<AuthorizationRequest> createTransfer(Transfer transfer) async {
    try {
      String path = 'transactions';

      var data = await post(path, body: transfer.toJson());

      return AuthorizationRequest.fromJson(data);
    } catch (e) {
      log(e.toString());
      throw Exception("Failed to create transfer");
    }
  }

  Future<TransactionsServiceResponse> getTransactions({
    TransactionListFilter? filter,
    User? user,
  }) async {
    if (user != null) {
      this.user = user;
    }
    try {
      var data = await get(
        '/transactions',
        queryParameters: filter?.toMap() ?? {},
      );

      List<Transaction> transactions = (data as List)
          .map((transaction) => Transaction.fromJson(transaction))
          .toList();

      return GetTransactionsSuccessResponse(transactions: transactions);
    } catch (e) {
      return TransactionsServiceErrorResponse();
    }
  }

  Future<UpcomingTransactionServiceResponse> getUpcomingTransactions({
    User? user,
  }) async {
    if (user != null) {
      this.user = user;
    }

    try {
      var data = await get('/account/transactions/credit_card_bills');

      List<UpcomingTransaction> upcomingTransactions = (data as List)
          .map((transaction) => UpcomingTransaction.fromJson(transaction))
          .toList();

      upcomingTransactions.addAll({
        UpcomingTransaction(
          statementDate: DateTime.now(),
          dueDate: DateTime.now(),
          outstandingAmount:
              CardBillAmount(value: 496.22, unit: "cents", currency: "EUR"),
        ),
        // UpcomingTransaction(
        //   statementDate: DateTime.now().add(const Duration(days: 7)),
        //   dueDate: DateTime.now().add(const Duration(days: 7)),
        //   outstandingAmount:
        //       CardBillAmount(value: 123.45, unit: "cents", currency: "EUR"),
        // ),
      });

      return GetUpcomingTransactionsSuccessResponse(
          upcomingTransactions: upcomingTransactions);
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

class GetUpcomingTransactionsSuccessResponse
    extends UpcomingTransactionServiceResponse {
  final List<UpcomingTransaction> upcomingTransactions;

  GetUpcomingTransactionsSuccessResponse({required this.upcomingTransactions});

  @override
  List<Object?> get props => [upcomingTransactions];
}

class UpcomingTransactionsServiceErrorResponse
    extends UpcomingTransactionServiceResponse {}

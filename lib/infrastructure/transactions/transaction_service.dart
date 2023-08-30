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

      List<Transaction> transactions = (data as List).map((transaction) => Transaction.fromJson(transaction)).toList();

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

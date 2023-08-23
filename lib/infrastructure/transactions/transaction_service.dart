import 'dart:developer';

import 'package:equatable/equatable.dart';

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
    if(user != null) {this.user = user;}
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
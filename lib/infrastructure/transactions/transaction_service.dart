import 'dart:developer';

import 'package:equatable/equatable.dart';

import '../../models/user.dart';
import '../../services/api_service.dart';
import '../../models/transfer.dart';
import '../../utilities/format.dart';
import '../../models/transaction_model.dart';
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

class TransactionListFilter {
  final DateTime? bookingDateMin;
  final DateTime? bookingDateMax;
  final int? page;
  final int? size;
  final String? sort;

  const TransactionListFilter({
    this.bookingDateMin,
    this.bookingDateMax,
    this.page,
    this.size,
    this.sort,
  });

  Map<String, String> toMap() {
    Map<String, String> map = {};

    if (bookingDateMin != null) {
      map["filter[booking_date][min]"] = Format.date(bookingDateMin!);
    }

    if (bookingDateMax != null) {
      map["filter[booking_date][max]"] = Format.date(bookingDateMax!);
    }

    if (page != null) {
      map["page[number]"] = page.toString();
    }

    if (size != null) {
      map["page[size]"] = size.toString();
    }

    if (sort != null) {
      map["sort"] = sort!;
    }

    return map;
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
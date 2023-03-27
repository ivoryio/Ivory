import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:solarisdemo/services/api_service.dart';

import '../config.dart';
import '../models/oauth_model.dart';
import '../models/transaction_model.dart';

class TransactionService extends ApiService {
  TransactionService({required super.user});

  Future<List<Transaction>?> getTransactions() async {
    try {
      var data = await get('/transactions');

      List<Transaction>? transactions = (data as List)
          .map((transaction) => Transaction.fromJson(transaction))
          .toList();

      return transactions;
    } catch (e) {
      throw Exception("Failed to load transactions");
    }
  }
}

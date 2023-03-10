import 'dart:convert';

import 'package:http/http.dart' as http;

import 'service_constants.dart';
import '../models/oauth_model.dart';
import '../models/transaction_model.dart';

class TransactionService {
  final OauthModel oauthModel;

  TransactionService({required this.oauthModel});

  Future<List<Transaction>?> getTransactions() async {
    try {
      const String accountId = '817b55aa12212e748e8cc2af91544ea2kcom';
      const String queryFilters =
          'page[size]=5&page[number]=1&filter[booking_date][min]=2000-10-10&filter[booking_date][max]=2030-10-10';

      const url = '$apiBaseUrl/v1/accounts/$accountId/bookings?$queryFilters';

      final response = await http.get(Uri.parse(url),
          headers: {"Authorization": "Bearer ${oauthModel.accessToken}"});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List<dynamic>;
        var transactions = data.map((e) => Transaction.fromJson(e)).toList();

        return transactions;
      }
      throw Exception('Failed to load transactions');
    } catch (e) {
      throw Exception("Failed to load transactions");
    }
  }
}

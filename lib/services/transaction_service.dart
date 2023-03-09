import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:solaris_structure_1/models/transaction.dart';

class TransactionService {
  Future<List<Transaction>?> getTransactions() async {
    try {
      const String baseUrl = 'http://localhost:8080';
      const String accountId = '817b55aa12212e748e8cc2af91544ea2kcom';
      const String queryFilters =
          'page[size]=5&page[number]=1&filter[booking_date][min]=2000-10-10&filter[booking_date][max]=2030-10-10';
      const String accessToken = 'MTY3ODM1NzE0ODE5NDo1Mzk';

      const url = '$baseUrl/v1/accounts/$accountId/bookings?$queryFilters';
      Map<String, String> headers = {"Authorization": "Bearer $accessToken"};

      final response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body) as List<dynamic>;
        var transactions = data.map((e) => Transaction.fromJson(e)).toList();

        return transactions;
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      return null;
    }
  }
}

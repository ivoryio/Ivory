import '../models/transaction_model.dart';
import 'package:solarisdemo/services/api_service.dart';

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

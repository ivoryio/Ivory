import '../models/transaction_model.dart';
import 'package:solarisdemo/services/api_service.dart';

class TransactionService extends ApiService {
  TransactionService({required super.user});

  Future<List<Transaction>?> getTransactions({
    TransactionListFilter? filter,
  }) async {
    try {
      var data = await get(
        '/transactions',
        queryParameters: filter?.toMap() ?? {},
      );

      List<Transaction>? transactions = (data as List)
          .map((transaction) => Transaction.fromJson(transaction))
          .toList();

      return transactions;
    } catch (e) {
      throw Exception("Failed to load transactions");
    }
  }
}

class TransactionListFilter {
  final String? bookingDateMin;
  final String? bookingDateMax;
  final int? page;
  final int? size;

  TransactionListFilter({
    this.bookingDateMin,
    this.bookingDateMax,
    this.page,
    this.size,
  });

  Map<String, String> toMap() {
    Map<String, String> map = {};

    if (bookingDateMin != null) {
      map["filter[booking_date][min]"] = bookingDateMin!;
    }

    if (bookingDateMax != null) {
      map["filter[booking_date][max]"] = bookingDateMax!;
    }

    if (page != null) {
      map["page[number]"] = page.toString();
    }

    if (size != null) {
      map["page[size]"] = size.toString();
    }

    return map;
  }
}

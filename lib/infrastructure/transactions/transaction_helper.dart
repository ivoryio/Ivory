import 'package:solarisdemo/models/transaction_model.dart';

class TransactionsHelper {

  static List<Transaction> searchTransactions(String searchTerm, List<Transaction> transactions) {
    final trimmedSearchTerm =  searchTerm.toLowerCase().trim();
    List<Transaction> filteredTransactions = transactions
        .where(
          (transaction) =>
      transaction.description!
          .toLowerCase()
          .contains(trimmedSearchTerm) ||
          transaction.recipientName!
              .toLowerCase()
              .contains(trimmedSearchTerm) ||
          transaction.senderName!
              .toLowerCase()
              .contains(trimmedSearchTerm),
    )
        .toList();
    return filteredTransactions;
  }

}
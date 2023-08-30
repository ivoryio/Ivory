import 'package:flutter_test/flutter_test.dart';
import 'package:solarisdemo/infrastructure/transactions/transaction_presenter.dart';
import 'package:solarisdemo/models/amount_value.dart';
import 'package:solarisdemo/models/transactions/transaction_model.dart';
import 'package:solarisdemo/models/transactions/upcoming_transaction_model.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';

void main() {
  final transaction1 = Transaction(
    id: "6e40fbd5-d7fa-5656-bff8-e19a8f4fa540",
    bookingType: "SEPA_CREDIT_TRANSFER",
    amount: AmountValue(currency: "EUR", unit: "cents", value: -100),
    description: "test transfer",
    senderIban: "DE60110101014274796688",
    senderName: "THINSLICES MAIN",
    recipientName: "Ionut",
    recordedAt: DateTime.parse("2023-07-05T09:06:02Z"),
  );

  final transaction2 = Transaction(
    id: "6e40fbd5-d7fa-5656-bff8-e19a8f4fa540",
    bookingType: "INTERNAL_TRANSFER",
    amount: AmountValue(currency: "EUR", unit: "cents", value: -100),
    description: "Top up from Omega to Alpha",
    senderIban: "DE60110101014274796688",
    senderName: "THINSLICES MAIN",
    recipientName: "Ionut",
    recordedAt: DateTime.parse("2023-07-05T09:06:02Z"),
  );

  final transaction3 = Transaction(
    id: "6e40fbd5-d7fa-5656-bff8-e19a8f4fa540",
    bookingType: "SEPA_CREDIT_TRANSFER",
    amount: AmountValue(currency: "EUR", unit: "cents", value: -100),
    description: "Rent",
    senderIban: "DE60110101014274796688",
    senderName: "THINSLICES MAIN",
    recipientName: "Stefan",
    recipientIban: "DE96110101014687145950",
    recordedAt: DateTime.parse("2023-07-05T09:06:02Z"),
  );

  final List<Transaction> transactions = [transaction1, transaction2, transaction3];

  final upcomingTransactions1 = UpcomingTransaction(
    id: "6e40fbd5-d7fa-5656-bff8-e19a8f4fa540",
    dueDate: DateTime.parse("2023-07-05T09:06:02Z"),
    outstandingAmount: AmountValue(
      currency: "EUR",
      unit: "cents",
      value: 100,
    ),
  );

  final upcomingTransactions2 = UpcomingTransaction(
    id: "6e40fbd5-d7fa-5656-bff8-e19a8f4fa540",
    dueDate: DateTime.parse("2023-07-05T09:06:02Z"),
    outstandingAmount: AmountValue(
      currency: "EUR",
      unit: "cents",
      value: 100,
    ),
  );

  final upcomingTransactions3 = UpcomingTransaction(
    id: "6e40fbd5-d7fa-5656-bff8-e19a8f4fa540",
    dueDate: DateTime.parse("2023-07-05T09:06:02Z"),
    outstandingAmount: AmountValue(
      currency: "EUR",
      unit: "cents",
      value: 100,
    ),
  );

  final List<UpcomingTransaction> upcomingTransactions = [
    upcomingTransactions1,
    upcomingTransactions2,
    upcomingTransactions3
  ];

  test("When fetching is in progress should return loading", () {
    //given
    final transactionsState = TransactionsLoadingState(null);
    //when
    final viewModel = TransactionPresenter.presentTransactions(transactionsState: transactionsState);
    //then
    expect(viewModel, const TransactionsLoadingViewModel());
  });

  test("When fetching is successful should return a list of transactions", () {
    //given
    final transactionsState = TransactionsFetchedState(transactions, null);
    //when
    final viewModel = TransactionPresenter.presentTransactions(transactionsState: transactionsState);
    //then
    expect(viewModel, TransactionsFetchedViewModel(transactions: transactions));
  });

  test("When fetching fails should return error", () {
    //given
    final transactionsState = TransactionsErrorState();
    //when
    final viewModel = TransactionPresenter.presentTransactions(transactionsState: transactionsState);
    //then
    expect(viewModel, TransactionsErrorViewModel());
  });

  test("When fetching upcoming transactions is successful should return a list of upcoming transactions", () {
    //given
    final upcomingTransactionsState = UpcomingTransactionsFetchedState(upcomingTransactions, null);
    //when
    final viewModel = TransactionPresenter.presentTransactions(transactionsState: upcomingTransactionsState);
    //then
    expect(viewModel, UpcomingTransactionsFetchedViewModel(upcomingTransactions: upcomingTransactions));
  });
}

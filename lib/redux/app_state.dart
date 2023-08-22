import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/categories/category_state.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_state.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_state.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';

class AppState extends Equatable {
  final TransactionsState transactionsState;
  final CreditLineState creditLineState;
  final RepaymentReminderState repaymentReminderState;
  final CategoriesState categoriesState;

  const AppState({
    required this.transactionsState,
    required this.creditLineState,
    required this.repaymentReminderState,
    required this.categoriesState,
  });

  factory AppState.initialState() {
    return AppState(
      transactionsState: TransactionsInitialState(),
      creditLineState: CreditLineInitialState(),
      repaymentReminderState: RepaymentReminderInitialState(),
      categoriesState: CategoriesInitialState(),
    );
  }

  @override
  List<Object?> get props => [
        transactionsState,
        creditLineState,
        repaymentReminderState,
      ];

  @override
  bool get stringify => true;
}

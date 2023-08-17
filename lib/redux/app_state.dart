import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/bank_card/activation/bank_card_activation_state.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_state.dart';
import 'package:solarisdemo/redux/repayments/reminder/repayment_reminder_state.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';

class AppState extends Equatable {
  final TransactionsState transactionsState;
  final CreditLineState creditLineState;
  final RepaymentReminderState repaymentReminderState;
  final BankCardActivationState bankCardActivationState;

  const AppState({
    required this.transactionsState,
    required this.creditLineState,
    required this.repaymentReminderState,
    required this.bankCardActivationState,
  });

  factory AppState.initialState() {
    return AppState(
      transactionsState: TransactionsInitialState(),
      creditLineState: CreditLineInitialState(),
      repaymentReminderState: RepaymentReminderInitialState(),
      bankCardActivationState: BankCardActivationInitialState(),
    );
  }

  @override
  List<Object?> get props => [
        transactionsState,
        creditLineState,
        repaymentReminderState,
        bankCardActivationState,
      ];

  @override
  bool get stringify => true;
}

import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_state.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';

class AppState extends Equatable {
  final TransactionsState transactionsState;
  final CreditLineState creditLineState;

  const AppState({
    required this.transactionsState,
    required this.creditLineState,
  });

  factory AppState.initialState() {
    return AppState(
      transactionsState: TransactionsInitialState(),
      creditLineState: CreditLineInitialState(),
    );
  }

  @override
  List<Object?> get props => [transactionsState, creditLineState];

  @override
  bool get stringify => true;
}

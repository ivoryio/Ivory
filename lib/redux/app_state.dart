import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/transactions/transactions_state.dart';

class AppState extends Equatable {

  final TransactionsState transactionsState;

  AppState({
    required this.transactionsState,
  });

  factory AppState.initialState() {
    return AppState(
      transactionsState: TransactionsInitialState(),
    );
  }

  @override
  List<Object?> get props => [transactionsState];

  @override
  bool get stringify => true;
}
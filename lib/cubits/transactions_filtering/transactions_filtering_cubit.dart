import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transactions_filtering_state.dart';

class TransactionsFilteringCubit extends Cubit<TransactionsFilteringState> {
  TransactionsFilteringCubit() : super(TransactionsFilteringInitial());

  void closeFiltersScreen() {
    emit(TransactionsFilteringInitial());
  }

  void setupFilters() {
    emit(TransactionsSetupFilters());
  }
}

import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/repayments/bills/bill.dart';

abstract class BillsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BillsInitialState extends BillsState {}

class BillsLoadingState extends BillsState {}

class BillsErrorState extends BillsState {}

class BillsFetchedState extends BillsState {
  final List<Bill> bills;
  BillsFetchedState(this.bills);

  @override
  List<Object?> get props => [bills];
}

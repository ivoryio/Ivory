import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/person_account_summary.dart';

abstract class AccountSummaryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccountSummaryInitialState extends AccountSummaryState {}

class AccountSummaryLoadingState extends AccountSummaryState {}

class AccountSummaryErrorState extends AccountSummaryState {}

class WithAccountSummaryState extends AccountSummaryState {
  final PersonAccountSummary accountSummary;

  WithAccountSummaryState(this.accountSummary);

  @override
  List<Object?> get props => [accountSummary];
}

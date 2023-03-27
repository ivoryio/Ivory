part of 'account_summary_cubit.dart';

abstract class AccountSummaryCubitState extends Equatable {
  final bool loading;
  final PersonAccountSummary? data;

  const AccountSummaryCubitState({this.loading = false, this.data});

  @override
  List<Object> get props => [loading];
}

class AccountSummaryCubitInitial extends AccountSummaryCubitState {
  const AccountSummaryCubitInitial() : super(loading: true, data: null);
}

class AccountSummaryCubitLoading extends AccountSummaryCubitState {
  const AccountSummaryCubitLoading() : super(loading: true, data: null);
}

class AccountSummaryCubitLoaded extends AccountSummaryCubitState {
  const AccountSummaryCubitLoaded(PersonAccountSummary accountSummary)
      : super(loading: false, data: accountSummary);
}

class AccountSummaryCubitError extends AccountSummaryCubitState {
  const AccountSummaryCubitError() : super(loading: false, data: null);
}

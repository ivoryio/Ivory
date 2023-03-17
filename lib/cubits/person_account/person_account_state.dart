part of 'person_account_cubit.dart';

abstract class PersonAccountState extends Equatable {
  final bool loading;
  final bool error;
  final PersonAccount? personAccount;

  const PersonAccountState({
    this.error = false,
    this.loading = false,
    this.personAccount,
  });

  @override
  List<Object> get props => [loading];
}

class PersonAccountInitial extends PersonAccountState {}

class PersonAccountLoading extends PersonAccountState {
  const PersonAccountLoading() : super(loading: true, personAccount: null);
}

class PersonAccountLoaded extends PersonAccountState {
  const PersonAccountLoaded(PersonAccount personAccount)
      : super(loading: false, personAccount: personAccount);
}

class PersonAccountError extends PersonAccountState {
  const PersonAccountError()
      : super(loading: false, error: true, personAccount: null);
}

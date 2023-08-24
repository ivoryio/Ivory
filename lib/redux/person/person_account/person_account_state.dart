import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/person_account.dart';

abstract class PersonAccountState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PersonAccountInitialState extends PersonAccountState {}

class PersonAccountLoadingState extends PersonAccountState {}

class PersonAccountFetchedState extends PersonAccountState {
  final PersonAccount personAccount;

  PersonAccountFetchedState(this.personAccount);

  @override
  List<Object?> get props => [personAccount];
}

class PersonAccountErrorState extends PersonAccountState {}

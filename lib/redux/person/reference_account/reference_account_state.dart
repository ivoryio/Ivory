import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/person/person_reference_account.dart';
import 'package:solarisdemo/models/person/person_service_error_type.dart';

abstract class ReferenceAccountState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReferenceAccountInitialState extends ReferenceAccountState {}

class ReferenceAccountLoadingState extends ReferenceAccountState {
  ReferenceAccountLoadingState();
}

class ReferenceAccountFetchedState extends ReferenceAccountState {
  final PersonReferenceAccount referenceAccount;

  ReferenceAccountFetchedState(this.referenceAccount);

  @override
  List<Object?> get props => [referenceAccount];
}

class ReferenceAccountErrorState extends ReferenceAccountState {
  final PersonServiceErrorType errorType;

  ReferenceAccountErrorState({required this.errorType});
}

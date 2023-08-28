import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/person/person_reference_account.dart';
import 'package:solarisdemo/models/person/person_service_error_type.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_state.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_state.dart';

class TransferAccountsPresenter {
  static TransferAccountsViewModel presentTransfer({
    required ReferenceAccountState referenceAccountState,
    required PersonAccountState personAccountState,
  }) {
    if (referenceAccountState is ReferenceAccountErrorState) {
      if (referenceAccountState.errorType == PersonServiceErrorType.referenceAccountUnavailable) {
        return const TransferAccountsErrorViewModel(errorType: TransferAccountsErrorType.referenceAccountUnavailable);
      }
      return const TransferAccountsErrorViewModel();
    } else if (personAccountState is PersonAccountErrorState) {
      return const TransferAccountsErrorViewModel();
    } else if (referenceAccountState is ReferenceAccountFetchedState &&
        personAccountState is PersonAccountFetchedState) {
      return TransferAccountsFetchedViewModel(
        referenceAccount: referenceAccountState.referenceAccount,
        personAccount: personAccountState.personAccount,
      );
    } else if (referenceAccountState is ReferenceAccountLoadingState ||
        personAccountState is PersonAccountLoadingState) {
      return TransferAccountsLoadingViewModel();
    }

    return TransferAccountsInitialViewModel();
  }
}

enum TransferAccountsErrorType { unknown, referenceAccountUnavailable }

abstract class TransferAccountsViewModel extends Equatable {
  const TransferAccountsViewModel();

  @override
  List<Object?> get props => [];
}

class TransferAccountsInitialViewModel extends TransferAccountsViewModel {}

class TransferAccountsLoadingViewModel extends TransferAccountsViewModel {}

class TransferAccountsFetchedViewModel extends TransferAccountsViewModel {
  final PersonAccount personAccount;
  final PersonReferenceAccount referenceAccount;

  const TransferAccountsFetchedViewModel({
    required this.personAccount,
    required this.referenceAccount,
  });

  @override
  List<Object?> get props => [personAccount, referenceAccount];
}

class TransferAccountsErrorViewModel extends TransferAccountsViewModel {
  final TransferAccountsErrorType errorType;

  const TransferAccountsErrorViewModel({
    this.errorType = TransferAccountsErrorType.unknown,
  });

  @override
  List<Object?> get props => [errorType];
}

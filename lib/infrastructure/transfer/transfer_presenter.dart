import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/person/person_reference_account.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_state.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_state.dart';

class TransferPresenter {
  static TransferViewModel presentTransfer({
    required ReferenceAccountState referenceAccountState,
    required PersonAccountState personAccountState,
  }) {
    if (referenceAccountState is ReferenceAccountErrorState || personAccountState is PersonAccountErrorState) {
      return TransferErrorViewModel();
    } else if (referenceAccountState is ReferenceAccountFetchedState &&
        personAccountState is PersonAccountFetchedState) {
      return TransferFetchedAccountsViewModel(
        referenceAccount: referenceAccountState.referenceAccount,
        personAccount: personAccountState.personAccount,
      );
    } else if (referenceAccountState is ReferenceAccountLoadingState ||
        personAccountState is PersonAccountLoadingState) {
      return TransferLoadingViewModel();
    }

    return TransferInitialViewModel();
  }
}

abstract class TransferViewModel extends Equatable {
  const TransferViewModel();

  @override
  List<Object?> get props => [];
}

class TransferInitialViewModel extends TransferViewModel {}

class TransferLoadingViewModel extends TransferViewModel {}

class TransferFetchedAccountsViewModel extends TransferViewModel {
  final PersonAccount personAccount;
  final PersonReferenceAccount referenceAccount;

  const TransferFetchedAccountsViewModel({
    required this.personAccount,
    required this.referenceAccount,
  });

  @override
  List<Object?> get props => [personAccount, referenceAccount];
}

class TransferErrorViewModel extends TransferViewModel {}

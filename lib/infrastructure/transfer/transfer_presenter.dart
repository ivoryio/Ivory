import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/person/person_reference_account.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_state.dart';

class TransferPresenter {
  static TransferViewModel presentTransfer({
    required ReferenceAccountState referenceAccountState,
  }) {
    if (referenceAccountState is ReferenceAccountLoadingState) {
      return TransferLoadingViewModel();
    } else if (referenceAccountState is ReferenceAccountFetchedState) {
      return TransferFetchedAccountsViewModel(
        referenceAccount: referenceAccountState.referenceAccount,
      );
    } else if (referenceAccountState is ReferenceAccountErrorState) {
      return TransferErrorViewModel();
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
  final PersonReferenceAccount referenceAccount;

  const TransferFetchedAccountsViewModel({required this.referenceAccount});

  @override
  List<Object?> get props => [referenceAccount];
}

class TransferErrorViewModel extends TransferViewModel {}

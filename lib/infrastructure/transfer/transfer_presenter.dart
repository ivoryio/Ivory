import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_state.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_state.dart';
import 'package:solarisdemo/redux/transfer/transfer_state.dart';

class TransferPresenter {
  static TransferViewModel presentTransfer({
    required TransferState transferState,
    required PersonAccountState personAccountState,
    required ReferenceAccountState referenceAccountState,
  }) {
    if (personAccountState is PersonAccountFetchedState && referenceAccountState is ReferenceAccountFetchedState) {
      if (transferState is TransferLoadingState) {
        return TransferLoadingViewModel();
      } else if (transferState is TransferFailedState) {
        return TransferFailedViewModel();
      } else if (transferState is TransferNeedConfirmationState) {
        return TransferConfirmationViewModel(changeRequestId: transferState.transferAuthorizationRequest.id);
      } else if (transferState is TransferConfirmedState) {
        return TransferConfirmedViewModel();
      }
    } else {
      return TransferFailedViewModel();
    }

    return TransferInitialViewModel();
  }
}

abstract class TransferViewModel extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransferInitialViewModel extends TransferViewModel {}

class TransferLoadingViewModel extends TransferViewModel {}

class TransferFailedViewModel extends TransferViewModel {}

class TransferConfirmationViewModel extends TransferViewModel {
  final String changeRequestId;

  TransferConfirmationViewModel({required this.changeRequestId});

  @override
  List<Object?> get props => [changeRequestId];
}

class TransferConfirmedViewModel extends TransferViewModel {}

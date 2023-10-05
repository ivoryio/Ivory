import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/person/person_account/person_account_state.dart';
import 'package:solarisdemo/redux/person/reference_account/reference_account_state.dart';
import 'package:solarisdemo/redux/transfer/transfer_state.dart';

import '../../models/change_request/change_request_error_type.dart';

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
        return TransferFailedViewModel(errorType: transferState.errorType);
      } else if (transferState is TransferNeedConfirmationState) {
        return TransferConfirmationViewModel(changeRequestId: transferState.transferAuthorizationRequest.id);
      } else if (transferState is TransferConfirmedState) {
        return TransferConfirmedViewModel(amount: transferState.amount);
      }
    } else {
      return TransferFailedViewModel(errorType: ChangeRequestErrorType.unknown);
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

class TransferFailedViewModel extends TransferViewModel {
  final ChangeRequestErrorType errorType;

  TransferFailedViewModel({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}

class TransferConfirmationViewModel extends TransferViewModel {
  final String changeRequestId;

  TransferConfirmationViewModel({required this.changeRequestId});

  @override
  List<Object?> get props => [changeRequestId];
}

class TransferConfirmedViewModel extends TransferViewModel {
  final double amount;

  TransferConfirmedViewModel({required this.amount});

  @override
  List<Object?> get props => [amount];
}

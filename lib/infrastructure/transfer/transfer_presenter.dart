import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/person/reference_account_state.dart';

class TransferPresenter {
  static TransferViewModel presentTransfer({
    required ReferenceAccountState referenceAccountState,
  }) {
    return TransferInitialViewModel();
  }
}

abstract class TransferViewModel extends Equatable {
  const TransferViewModel();

  @override
  List<Object?> get props => [];
}

class TransferInitialViewModel extends TransferViewModel {}

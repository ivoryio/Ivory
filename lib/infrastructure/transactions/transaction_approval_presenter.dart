import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/bank_card.dart';
import 'package:solarisdemo/models/notifications/notification_transaction_message.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_state.dart';
import 'package:solarisdemo/redux/notification/notification_state.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_state.dart';

class TransactionApprovalPresenter {
  static TransactionApprovalViewModel present({
    required NotificationState notificationState,
    required TransactionApprovalState transactionApprovalState,
    required BankCardState bankCardState,
  }) {
    if (notificationState is NotificationTransactionApprovalState) {
      if (transactionApprovalState is TransactionApprovalLoadingState || bankCardState is BankCardLoadingState) {
        return WithMessageViewModel(message: notificationState.message, isLoading: true);
      } else if (transactionApprovalState is TransactionApprovalRejectedState) {
        return TransactionApprovalRejectedViewModel();
      } else if (transactionApprovalState is TransactionApprovalDeviceNotBoundedState) {
        return TransactionApprovalFailedViewModel(errorType: TransactionApprovalErrorType.unboundedDeviceError);
      } else if (transactionApprovalState is TransactionApprovalFailedState || bankCardState is BankCardErrorState) {
        return TransactionApprovalFailedViewModel(errorType: TransactionApprovalErrorType.unknownError);
      } else if (transactionApprovalState is TransactionApprovalAuthorizedState &&
          bankCardState is BankCardFetchedState) {
        return WithApprovalChallengeViewModel(
          isLoading: false,
          bankCard: bankCardState.bankCard,
          message: notificationState.message,
          deviceId: transactionApprovalState.deviceId,
          deviceData: transactionApprovalState.deviceData,
          stringToSign: transactionApprovalState.stringToSign,
          changeRequestId: transactionApprovalState.changeRequestId,
        );
      } else if (transactionApprovalState is TransactionApprovalSucceededState) {
        return TransactionApprovalSucceededViewModel();
      }

      return WithMessageViewModel(message: notificationState.message, isLoading: true);
    }

    return TransactionApprovalInitialViewModel();
  }
}

abstract class TransactionApprovalViewModel extends Equatable {
  @override
  List<Object> get props => [];
}

class TransactionApprovalInitialViewModel extends TransactionApprovalViewModel {}

class WithMessageViewModel extends TransactionApprovalViewModel {
  final bool isLoading;
  final NotificationTransactionMessage message;

  WithMessageViewModel({this.isLoading = false, required this.message});

  @override
  List<Object> get props => [isLoading, message];
}

class WithApprovalChallengeViewModel extends WithMessageViewModel {
  final String stringToSign;
  final String deviceId;
  final String deviceData;
  final String changeRequestId;
  final BankCard bankCard;

  WithApprovalChallengeViewModel({
    required this.stringToSign,
    required this.deviceId,
    required this.deviceData,
    required this.changeRequestId,
    required super.isLoading,
    required super.message,
    required this.bankCard,
  });

  @override
  List<Object> get props => [stringToSign, deviceId, deviceData, isLoading, message, changeRequestId, bankCard];
}

class TransactionApprovalSucceededViewModel extends TransactionApprovalViewModel {}

class TransactionApprovalFailedViewModel extends TransactionApprovalViewModel {
  final TransactionApprovalErrorType errorType;

  TransactionApprovalFailedViewModel({this.errorType = TransactionApprovalErrorType.unknownError});

  @override
  List<Object> get props => [errorType];
}

class TransactionApprovalRejectedViewModel extends TransactionApprovalViewModel {}

enum TransactionApprovalErrorType { unboundedDeviceError, biometricsError, rejected, unknownError }

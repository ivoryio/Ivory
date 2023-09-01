import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/notifications/notification_transaction_message.dart';
import 'package:solarisdemo/redux/notification/notification_state.dart';
import 'package:solarisdemo/redux/transactions/approval/transaction_approval_state.dart';

class TransactionApprovalPresenter {
  static TransactionApprovalViewModel present({
    required NotificationState notificationState,
    required TransactionApprovalState transactionApprovalState,
  }) {
    if (notificationState is NotificationTransactionApprovalState) {
      if (transactionApprovalState is TransactionApprovalLoadingState) {
        return TransactionApprovalWithMessageViewModel(message: notificationState.message, isLoading: true);
      } else if (transactionApprovalState is TransactionApprovalChallengeFetchedState) {
        return TransactionApprovalWithChallengeViewModel(
          isLoading: false,
          message: notificationState.message,
          stringToSign: transactionApprovalState.stringToSign,
          deviceId: transactionApprovalState.deviceId,
          deviceData: transactionApprovalState.deviceData,
          changeRequestId: transactionApprovalState.changeRequestId,
        );
      }

      return TransactionApprovalWithMessageViewModel(message: notificationState.message);
    }

    return TransactionApprovalInitialViewModel();
  }
}

abstract class TransactionApprovalViewModel extends Equatable {
  @override
  List<Object> get props => [];
}

class TransactionApprovalInitialViewModel extends TransactionApprovalViewModel {}

class TransactionApprovalWithMessageViewModel extends TransactionApprovalViewModel {
  final bool isLoading;
  final NotificationTransactionMessage message;

  TransactionApprovalWithMessageViewModel({this.isLoading = false, required this.message});

  @override
  List<Object> get props => [isLoading, message];
}

class TransactionApprovalWithChallengeViewModel extends TransactionApprovalWithMessageViewModel {
  final String stringToSign;
  final String deviceId;
  final String deviceData;
  final String changeRequestId;

  TransactionApprovalWithChallengeViewModel({
    required this.stringToSign,
    required this.deviceId,
    required this.deviceData,
    required this.changeRequestId,
    required super.isLoading,
    required super.message,
  });

  @override
  List<Object> get props => [stringToSign, deviceId, deviceData, isLoading, message, changeRequestId];
}

enum TransactionApprovalErrorType { unboundedDeviceError, unknownError }

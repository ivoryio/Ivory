import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/notifications/notification_transaction_message.dart';
import 'package:solarisdemo/redux/notification/notification_state.dart';

class TransactionApprovalPresenter {
  static TransactionApprovalViewModel present({
    required NotificationState notificationState,
  }) {
    if (notificationState is NotificationTransactionApprovalState) {
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

enum TransactionApprovalErrorType { unboundedDeviceError, unknownError }

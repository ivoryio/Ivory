import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/notifications/notification_transaction_message.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitialState extends NotificationState {}

class NotificationTransactionApprovalState extends NotificationState {
  final NotificationTransactionMessage message;

  NotificationTransactionApprovalState({required this.message});
}

class NotificationScoringSuccessfulState extends NotificationState {}

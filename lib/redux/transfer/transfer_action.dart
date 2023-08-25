import 'package:solarisdemo/models/user.dart';

class TransferCommandAction {
  final User user;

  TransferCommandAction({required this.user});
}

class ConfirmTransferCommandAction {
  final User user;

  ConfirmTransferCommandAction({required this.user});
}

class SendTransferSuccessEventAction {}

class SendTransferFailedEventAction {}

class ConfirmTransferSuccessEventAction {}

class ConfirmTransferFailedEventAction {}

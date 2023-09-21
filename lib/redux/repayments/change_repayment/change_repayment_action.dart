import 'package:solarisdemo/models/user.dart';

class GetChangeRepaymentAction {
  final User user;
  GetChangeRepaymentAction({required this.user});
}

class UpdateChangeRepaymentAction {
  final double fixedRate;

  UpdateChangeRepaymentAction({
    required this.fixedRate,
  });
}

class ChangeRepaymentLoadingAction {}

class ChangeRepaymentFailedAction {}

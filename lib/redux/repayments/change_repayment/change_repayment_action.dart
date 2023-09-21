import 'package:solarisdemo/models/user.dart';

class GetChangeRepaymentAction {
  final AuthenticatedUser user;
  GetChangeRepaymentAction({required this.user});
}

class UpdateChangeRepaymentCommandAction {
  final AuthenticatedUser user;
  final double fixedRate;

  UpdateChangeRepaymentCommandAction({
    required this.user,
    required this.fixedRate,
  });
}

class UpdateChangeRepaymentEventAction {
  final double fixedRate;

  UpdateChangeRepaymentEventAction({
    required this.fixedRate,
  });
}

class ChangeRepaymentLoadingAction {}

class ChangeRepaymentFailedAction {}

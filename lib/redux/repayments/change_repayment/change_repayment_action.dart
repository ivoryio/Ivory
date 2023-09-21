import 'package:solarisdemo/models/user.dart';

class GetChangeRepaymentAction {
  final AuthenticatedUser user;
  GetChangeRepaymentAction({required this.user});
}

class UpdateChangeRepaymentAction {
  final AuthenticatedUser user;
  final double fixedRate;

  UpdateChangeRepaymentAction({
    required this.user,
    required this.fixedRate,
  });
}

class ChangeRepaymentLoadingAction {}

class ChangeRepaymentFailedAction {}

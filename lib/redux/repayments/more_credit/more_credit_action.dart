import 'package:solarisdemo/models/user.dart';

class GetMoreCreditCommandAction {
  final User user;

  GetMoreCreditCommandAction({
    required this.user,
  });
}

class MoreCreditLoadingEventAction {}

class MoreCreditFailedEventAction {}

class MoreCreditFetchedEventAction {
  final bool waitlist;

  MoreCreditFetchedEventAction({required this.waitlist});
}

class UpdateMoreCreditCommandAction {
  final User user;

  UpdateMoreCreditCommandAction({
    required this.user,
  });
}

class GetMoreCreditCommandAction {}

class MoreCreditLoadingEventAction {}

class MoreCreditFailedEventAction {}

class MoreCreditFetchedEventAction {
  final bool waitlist;

  MoreCreditFetchedEventAction({required this.waitlist});
}

class UpdateMoreCreditCommandAction {}

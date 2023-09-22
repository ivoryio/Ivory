import 'package:solarisdemo/models/transfer/credit_card_application.dart';
import 'package:solarisdemo/models/user.dart';

class UpdateCardApplicationCommandAction {
  final AuthenticatedUser user;
  final double fixedRate;
  final String id;

  UpdateCardApplicationCommandAction({
    required this.user,
    required this.fixedRate,
    required this.id,
  });
}

class UpdateCardApplicationEventAction {
  final CreditCardApplication creditCardApplication;

  UpdateCardApplicationEventAction({
    required this.creditCardApplication,
  });
}

class GetCardApplicationCommandAction {
  final AuthenticatedUser user;

  GetCardApplicationCommandAction({required this.user});
}

class CardApplicationFetchedEventAction {
  final CreditCardApplication creditCardApplication;

  CardApplicationFetchedEventAction({required this.creditCardApplication});
}

class CardApplicationLoadingEventAction {}

class CardApplicationFailedEventAction {}
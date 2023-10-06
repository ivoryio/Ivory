import 'package:solarisdemo/models/transfer/credit_card_application.dart';
import 'package:solarisdemo/models/user.dart';

class UpdateCardApplicationCommandAction {
  final User user;
  final double fixedRate;
  final int percentageRate;
  final String id;

  UpdateCardApplicationCommandAction({
    required this.user,
    required this.fixedRate,
    required this.percentageRate,
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
  final User user;

  GetCardApplicationCommandAction({required this.user});
}

class CardApplicationFetchedEventAction {
  final CreditCardApplication creditCardApplication;

  CardApplicationFetchedEventAction({required this.creditCardApplication});
}

class CardApplicationLoadingEventAction {}

class CardApplicationFailedEventAction {}

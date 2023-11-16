import 'package:solarisdemo/models/transfer/credit_card_application.dart';

class UpdateCardApplicationCommandAction {
  final double fixedRate;
  final int percentageRate;
  final String id;

  UpdateCardApplicationCommandAction({
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

class GetCardApplicationCommandAction {}

class CardApplicationFetchedEventAction {
  final CreditCardApplication creditCardApplication;

  CardApplicationFetchedEventAction({required this.creditCardApplication});
}

class CardApplicationLoadingEventAction {}

class CardApplicationFailedEventAction {}

import 'package:solarisdemo/models/credit_line.dart';
import 'package:solarisdemo/models/user.dart';

class GetCreditLineCommandAction {
  final User user;
  GetCreditLineCommandAction({required this.user});
}

class CreditLineLoadingEventAction {}

class CreditLineFailedEventAction {}

class CreditLineFetchedEventAction {
  final CreditLine creditLine;
  CreditLineFetchedEventAction({required this.creditLine});
}

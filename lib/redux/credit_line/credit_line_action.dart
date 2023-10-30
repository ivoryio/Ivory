import 'package:solarisdemo/models/credit_line.dart';

class GetCreditLineCommandAction {}

class CreditLineLoadingEventAction {}

class CreditLineFailedEventAction {}

class CreditLineFetchedEventAction {
  final CreditLine creditLine;
  CreditLineFetchedEventAction({required this.creditLine});
}

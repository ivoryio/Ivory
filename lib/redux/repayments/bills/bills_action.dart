import 'package:solarisdemo/models/repayments/bills/bill.dart';
import 'package:solarisdemo/models/user.dart';

class GetBillsCommandAction {
  final User user;
  GetBillsCommandAction({required this.user});
}

class BillsLoadingEventAction {}

class BillsFailedEventAction {}

class BillsFetchedEventAction {
  final List<Bill> bills;
  BillsFetchedEventAction({required this.bills});
}

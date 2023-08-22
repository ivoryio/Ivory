import 'package:solarisdemo/models/repayments/bills/bill.dart';
import 'package:solarisdemo/models/user.dart';

class GetBillsCommandAction {
  final User user;
  GetBillsCommandAction({required this.user});
}

class DownloadBillCommandAction {
  final Bill bill;
  DownloadBillCommandAction({required this.bill});
}

class BillsLoadingEventAction {}

class BillDownloadingEventAction {}

class BillsFailedEventAction {}

class BillsFetchedEventAction {
  final List<Bill> bills;
  BillsFetchedEventAction({required this.bills});
}

class DownloadBillSuccessEventAction {}

class DownloadBillFailedEventAction {}

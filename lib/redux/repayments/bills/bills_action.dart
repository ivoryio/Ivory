import 'package:flutter/foundation.dart';
import 'package:solarisdemo/models/repayments/bills/bill.dart';
import 'package:solarisdemo/models/user.dart';

class GetBillsCommandAction {
  final User user;
  GetBillsCommandAction({required this.user});
}

class GetBillByIdCommandAction {
  final String id;
  final User user;
  GetBillByIdCommandAction({required this.id, required this.user});
}

class DownloadBillCommandAction {
  final Bill bill;
  final VoidCallback? onDownloaded;
  final VoidCallback? onDownloadFailed;
  DownloadBillCommandAction({required this.bill, this.onDownloaded, this.onDownloadFailed});
}

class BillsLoadingEventAction {}

class BillDownloadingEventAction {}

class BillsFailedEventAction {}

class BillsFetchedEventAction {
  final List<Bill> bills;
  BillsFetchedEventAction({required this.bills});
}

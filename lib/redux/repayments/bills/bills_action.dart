import 'package:flutter/foundation.dart';
import 'package:solarisdemo/models/repayments/bills/bill.dart';

class GetBillsCommandAction {}

class GetBillByIdCommandAction {
  final String id;
  GetBillByIdCommandAction({required this.id});
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

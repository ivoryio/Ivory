import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/repayments/bills/bill.dart';
import 'package:solarisdemo/redux/repayments/bills/bills_state.dart';

class BillDetailPresenter {
  static BillDetailViewModel presentBillDetail({required BillsState billState, required String billId}) {
    if (billState is! BillsFetchedState) {
      throw Exception('BillDetailPresenter: billState is not BillsFetchedState');
    }

    final bill = billState.bills.firstWhere((element) => element.id == billId);
    final transactionsLoaded = bill.transactions != null;

    return BillDetailViewModel(bill: bill, transactionsLoaded: transactionsLoaded);
  }
}

class BillDetailViewModel extends Equatable {
  final Bill bill;
  final bool transactionsLoaded;
  const BillDetailViewModel({required this.bill, required this.transactionsLoaded});

  @override
  List<Object?> get props => [bill];
}

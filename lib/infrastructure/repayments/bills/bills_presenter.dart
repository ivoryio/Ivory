import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/repayments/bills/bill.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/repayments/bills/bills_state.dart';

class BillsPresenter {
  static BillsViewModel presentBills({required BillsState billState, required AuthenticatedUser user}) {
    if (billState is BillsLoadingState) {
      return BillsLoadingViewModel();
    } else if (billState is BillsErrorState) {
      return BillsErrorViewModel();
    } else if (billState is BillsFetchedState) {
      return BillsFetchedViewModel(bills: billState.bills);
    }

    return BillsInitialViewModel();
  }
}

abstract class BillsViewModel extends Equatable {
  const BillsViewModel();

  @override
  List<Object?> get props => [];
}

class BillsInitialViewModel extends BillsViewModel {}

class BillsLoadingViewModel extends BillsViewModel {}

class BillsErrorViewModel extends BillsViewModel {}

class BillsFetchedViewModel extends BillsViewModel {
  final List<Bill> bills;

  const BillsFetchedViewModel({required this.bills});

  @override
  List<Object?> get props => [bills];
}

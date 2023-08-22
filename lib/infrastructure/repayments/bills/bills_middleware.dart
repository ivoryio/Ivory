import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/repayments/bills/bill_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/repayments/bills/bills_action.dart';

class GetBillsMiddleware extends MiddlewareClass<AppState> {
  final BillService _billService;

  GetBillsMiddleware(this._billService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is GetBillsCommandAction) {
      store.dispatch(BillsLoadingEventAction());
      final response = await _billService.getBills(user: action.user);

      if (response is GetBillsSuccessResponse) {
        store.dispatch(BillsFetchedEventAction(bills: response.bills));
      } else {
        store.dispatch(BillsFailedEventAction());
      }
    }

    if (action is DownloadBillCommandAction) {
      store.dispatch(BillDownloadingEventAction());
      final response = await _billService.downloadBillAsPdf(postboxItemId: action.bill.postboxItemId);

      if (response != null) {
        store.dispatch(DownloadBillSuccessEventAction());
      } else {
        store.dispatch(DownloadBillFailedEventAction());
      }
    }
  }
}

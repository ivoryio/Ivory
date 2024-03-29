import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/documents/file_saver_service.dart';
import 'package:solarisdemo/infrastructure/repayments/bills/bill_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/repayments/bills/bills_action.dart';
import 'package:solarisdemo/redux/repayments/bills/bills_state.dart';

import '../../../redux/auth/auth_state.dart';

class GetBillsMiddleware extends MiddlewareClass<AppState> {
  final BillService _billService;
  final FileSaverService _fileSaverService;

  GetBillsMiddleware(this._billService, this._fileSaverService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    final authState = store.state.authState;
    if (authState is! AuthenticatedState) {
      return;
    }

    if (action is GetBillsCommandAction) {
      store.dispatch(BillsLoadingEventAction());
      final response = await _billService.getBills(user: authState.authenticatedUser.cognito);

      if (response is GetBillsSuccessResponse) {
        store.dispatch(BillsFetchedEventAction(bills: response.bills));
      } else {
        store.dispatch(BillsFailedEventAction());
      }
    }

    if (action is GetBillByIdCommandAction) {
      final response = await _billService.getBillById(id: action.id, user: authState.authenticatedUser.cognito);

      if (response is GetBillByIdSuccessResponse) {
        final newBills = (store.state.billsState as BillsFetchedState).bills.map((bill) {
          if (bill.id == action.id) {
            return response.bill;
          }

          return bill;
        }).toList();
        store.dispatch(BillsFetchedEventAction(bills: newBills));
      }
    }

    if (action is DownloadBillCommandAction) {
      store.dispatch(BillDownloadingEventAction());
      final response = await _billService.downloadBillAsPdf(postboxItemId: action.bill.postboxItemId);

      if (response != null) {
        await _fileSaverService.saveFile(
          name: action.bill.postboxItemId,
          ext: '.pdf',
          bytes: response,
          mimeType: 'application/pdf',
        );

        action.onDownloaded?.call();
      } else {
        action.onDownloadFailed?.call();
      }
    }
  }
}

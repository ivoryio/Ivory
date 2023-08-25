import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/change_request/change_request_service.dart';
import 'package:solarisdemo/infrastructure/transfer/transfer_service.dart';
import 'package:solarisdemo/redux/app_state.dart';

class TransferMiddleware extends MiddlewareClass<AppState> {
  final TransferService _transferService;
  final ChangeRequestService _changeRequestService;

  TransferMiddleware(this._transferService, this._changeRequestService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
  }
}

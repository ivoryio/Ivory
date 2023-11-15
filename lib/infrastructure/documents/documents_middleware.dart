import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/documents/documents_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/documents/documents_action.dart';

class DocumentsMiddleware extends MiddlewareClass<AppState> {
  final DocumentsService _documentsService;

  DocumentsMiddleware(this._documentsService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (action is GetDocumentsCommandAction) {
      store.dispatch(DocumentsLoadingEventAction());
    }
  }
}

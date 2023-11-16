import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/documents/documents_service.dart';
import 'package:solarisdemo/infrastructure/file_saver_service.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/documents/documents_action.dart';

class DocumentsMiddleware extends MiddlewareClass<AppState> {
  final DocumentsService _documentsService;
  final FileSaverService _fileSaverService;

  DocumentsMiddleware(this._documentsService, this._fileSaverService);

  @override
  call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    if (store.state.authState is! AuthenticationInitializedState) {
      return;
    }

    final authState = store.state.authState as AuthenticationInitializedState;

    if (action is GetDocumentsCommandAction) {
      store.dispatch(DocumentsLoadingEventAction());

      final response = await _documentsService.getPostboxDocuments(user: authState.cognitoUser);

      if (response is GetDocumentsSuccessResponse) {
        store.dispatch(DocumentsFetchedEventAction(documents: response.documents));
      } else if (response is DocumentsServiceErrorResponse) {
        store.dispatch(GetDocumentsFailedEventAction(errorType: response.errorType));
      }
    }

    if (action is DownloadDocumentCommandAction) {
      store.dispatch(DownloadDocumentLoadingEventAction(document: action.document));

      final response = await _documentsService.downloadPostboxDocument(
        user: authState.cognitoUser,
        document: action.document,
      );

      if (response is DownloadDocumentSuccessResponse) {
        await _fileSaverService.saveFile(
          name: action.document.fileName,
          ext: 'pdf',
          bytes: response.file,
          mimeType: 'application/pdf',
        );

        store.dispatch(DownloadDocumentSuccessEventAction());
      } else if (response is DocumentsServiceErrorResponse) {
        store.dispatch(DownloadDocumentFailedEventAction(errorType: response.errorType));
      }
    }
  }
}

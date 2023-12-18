import 'package:redux/redux.dart';
import 'package:solarisdemo/infrastructure/documents/documents_service.dart';
import 'package:solarisdemo/infrastructure/documents/file_saver_service.dart';
import 'package:solarisdemo/models/documents/documents_error_type.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/documents/documents_action.dart';
import 'package:solarisdemo/utilities/retry.dart';

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

      final response = await retry(
        () async => _documentsService.getPostboxDocuments(user: authState.cognitoUser),
        retryIf: (response) =>
            action.retryWhenBelowDocumentCount > 0 &&
            response is GetDocumentsSuccessResponse &&
            response.documents.length < action.retryWhenBelowDocumentCount,
        maxAttempts: action.maxRetryCount,
        delay: const Duration(seconds: 1),
      );

      if (response is GetDocumentsSuccessResponse) {
        if (action.retryWhenBelowDocumentCount > 0 && response.documents.length < action.retryWhenBelowDocumentCount) {
          store.dispatch(GetDocumentsFailedEventAction(errorType: DocumentsErrorType.emptyList));
          return;
        }

        store.dispatch(DocumentsFetchedEventAction(documents: response.documents));
      } else if (response is DocumentsServiceErrorResponse) {
        store.dispatch(GetDocumentsFailedEventAction(errorType: response.errorType));
      }
    }

    if (action is DownloadDocumentCommandAction) {
      store.dispatch(DownloadDocumentLoadingEventAction(document: action.document));

      final response = await _documentsService.downloadDocument(
        user: authState.cognitoUser,
        document: action.document,
        downloadLocation: action.downloadLocation,
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

    if (action is ConfirmDocumentsCommandAction) {
      store.dispatch(ConfirmDocumentsLoadingEventAction());

      final response = await _documentsService.confirmPostboxDocuments(
        user: authState.cognitoUser,
        documents: action.documents,
      );

      if (response is ConfirmDocumentsSuccessResponse) {
        store.dispatch(ConfirmDocumentsSuccessEventAction());
      } else if (response is DocumentsServiceErrorResponse) {
        store.dispatch(ConfirmDocumentsFailedEventAction(errorType: response.errorType));
      }
    }
  }
}

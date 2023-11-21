import 'package:solarisdemo/redux/documents/documents_action.dart';
import 'package:solarisdemo/redux/documents/download/download_document_state.dart';

DownloadDocumentState downloadDocumentReducer(DownloadDocumentState state, dynamic action) {
  if (action is DownloadDocumentLoadingEventAction) {
    return DocumentDownloadingState(document: action.document);
  } else if (action is DownloadDocumentSuccessEventAction) {
    return DocumentDownloadedState();
  } else if (action is DownloadDocumentFailedEventAction) {
    return DocumentDownloadErrorState(errorType: action.errorType);
  }

  return state;
}

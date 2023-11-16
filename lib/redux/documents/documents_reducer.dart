import 'package:solarisdemo/redux/documents/documents_action.dart';
import 'package:solarisdemo/redux/documents/documents_state.dart';

DocumentsState documentsReducer(DocumentsState state, dynamic action) {
  if (action is DocumentsLoadingEventAction) {
    return DocumentsInitialLoadingState();
  } else if (action is DocumentsFetchedEventAction) {
    return DocumentsFetchedState(documents: action.documents);
  } else if (action is GetDocumentsFailedEventAction) {
    return DocumentsErrorState(errorType: action.errorType);
  }

  return state;
}

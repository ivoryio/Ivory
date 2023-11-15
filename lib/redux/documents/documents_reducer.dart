import 'package:solarisdemo/redux/documents/documents_action.dart';
import 'package:solarisdemo/redux/documents/documents_state.dart';

DocumentsState documentsReducer(DocumentsState state, dynamic action) {
  if (action is DocumentsLoadingEventAction) {
    return DocumentsLoadingState();
  } else if (action is DocumentsFetchedEventAction) {
    return DocumentsFetchedState(documents: action.documents);
  }

  return state;
}

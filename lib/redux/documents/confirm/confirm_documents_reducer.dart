import 'package:solarisdemo/redux/documents/confirm/confirm_documents_state.dart';
import 'package:solarisdemo/redux/documents/documents_action.dart';

ConfirmDocumentsState confirmDocumentsReducer(ConfirmDocumentsState state, dynamic action) {
  if (action is ConfirmDocumentsLoadingEventAction) {
    return ConfirmDocumentsLoadingState();
  } else if (action is ConfirmedDocumentsEventAction) {
    return ConfirmedDocumentsState();
  } else if (action is ConfirmDocumentsFailedEventAction) {
    return ConfirmDocumentsErrorState(errorType: action.errorType);
  }

  return state;
}

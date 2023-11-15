import 'package:solarisdemo/models/documents/document.dart';
import 'package:solarisdemo/models/documents/documents_error_type.dart';

class GetDocumentsCommandAction {}

class DocumentsLoadingEventAction {}

class DocumentsFetchedEventAction {
  final List<Document> documents;

  DocumentsFetchedEventAction({required this.documents});
}

class GetDocumentsFailedEventAction {
  final DocumentsErrorType errorType;

  GetDocumentsFailedEventAction({required this.errorType});
}

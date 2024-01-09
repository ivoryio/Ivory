import 'package:solarisdemo/infrastructure/documents/documents_service.dart';
import 'package:solarisdemo/models/documents/document.dart';
import 'package:solarisdemo/models/documents/documents_error_type.dart';

class GetDocumentsCommandAction {
  final int retryWhenBelowDocumentCount;
  final int maxRetryCount;
  final Duration retryDelay;

  GetDocumentsCommandAction({
    this.maxRetryCount = 50,
    this.retryWhenBelowDocumentCount = 2,
    this.retryDelay = const Duration(seconds: 2),
  });
}

class DocumentsLoadingEventAction {}

class DocumentsFetchedEventAction {
  final List<Document> documents;

  DocumentsFetchedEventAction({required this.documents});
}

class GetDocumentsFailedEventAction {
  final DocumentsErrorType errorType;

  GetDocumentsFailedEventAction({required this.errorType});
}

class DownloadDocumentCommandAction {
  final Document document;
  final DocumentDownloadLocation downloadLocation;

  DownloadDocumentCommandAction({required this.document, required this.downloadLocation});
}

class DownloadDocumentLoadingEventAction {
  final Document document;

  DownloadDocumentLoadingEventAction({required this.document});
}

class DownloadDocumentSuccessEventAction {}

class DownloadDocumentFailedEventAction {
  final DocumentsErrorType errorType;

  DownloadDocumentFailedEventAction({required this.errorType});
}

class ConfirmDocumentsCommandAction {
  final List<Document> documents;

  ConfirmDocumentsCommandAction({required this.documents});
}

class ConfirmDocumentsLoadingEventAction {}

class ConfirmDocumentsSuccessEventAction {}

class ConfirmDocumentsFailedEventAction {
  final DocumentsErrorType errorType;

  ConfirmDocumentsFailedEventAction({required this.errorType});
}

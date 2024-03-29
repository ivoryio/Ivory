import 'dart:typed_data';

import 'package:mockito/mockito.dart';
import 'package:solarisdemo/infrastructure/documents/documents_service.dart';
import 'package:solarisdemo/infrastructure/documents/file_saver_service.dart';
import 'package:solarisdemo/models/documents/document.dart';
import 'package:solarisdemo/models/documents/documents_error_type.dart';
import 'package:solarisdemo/models/user.dart';

class MockDocumentsService extends Mock implements DocumentsService {
  @override
  Future<DocumentsServiceResponse> getPostboxDocuments({required User? user}) async {
    return super.noSuchMethod(
      Invocation.method(#getPostboxDocuments, [], {#user: user}),
      returnValue: Future.value(GetDocumentsSuccessResponse(documents: const [])),
      returnValueForMissingStub: Future.value(GetDocumentsSuccessResponse(documents: const [])),
    );
  }
}

class FakeDocumentsService extends DocumentsService {
  @override
  Future<DocumentsServiceResponse> getPostboxDocuments({required User user}) async {
    return GetDocumentsSuccessResponse(
      documents: const [
        Document(
          id: "documentId",
          documentType: DocumentType.creditCardContract,
          fileType: "PDF",
          fileSize: 12345,
        ),
        Document(
          id: "documentId2",
          documentType: DocumentType.creditCardSecci,
          fileType: "PDF",
          fileSize: 2048,
        ),
      ],
    );
  }

  @override
  Future<DocumentsServiceResponse> downloadDocument({
    required User user,
    required Document document,
    required DocumentDownloadLocation downloadLocation,
  }) async {
    return DownloadDocumentSuccessResponse(document: document, file: Uint8List(0));
  }

  @override
  Future<DocumentsServiceResponse> confirmPostboxDocuments({
    required User user,
    required List<Document> documents,
  }) async {
    return ConfirmDocumentsSuccessResponse();
  }
}

class FakeFailingDocumentsService extends DocumentsService {
  @override
  Future<DocumentsServiceResponse> getPostboxDocuments({required User user}) async {
    return DocumentsServiceErrorResponse(errorType: DocumentsErrorType.unknown);
  }

  @override
  Future<DocumentsServiceResponse> downloadDocument({
    required User user,
    required Document document,
    required DocumentDownloadLocation downloadLocation,
  }) async {
    return DocumentsServiceErrorResponse(errorType: DocumentsErrorType.unknown);
  }

  @override
  Future<DocumentsServiceResponse> confirmPostboxDocuments({
    required User user,
    required List<Document> documents,
  }) async {
    return DocumentsServiceErrorResponse(errorType: DocumentsErrorType.unknown);
  }
}

class FakeFileSaverService extends FileSaverService {
  @override
  Future<void> saveFile({required String name, String? ext, required Uint8List bytes, String? mimeType}) async {}
}

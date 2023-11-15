import 'package:solarisdemo/infrastructure/documents/documents_service.dart';
import 'package:solarisdemo/models/documents/document.dart';
import 'package:solarisdemo/models/documents/documents_error_type.dart';
import 'package:solarisdemo/models/user.dart';

class FakeDocumentsService extends DocumentsService {
  @override
  Future<DocumentsServiceResponse> getPostboxDocuments({required User user}) async {
    return GetDocumentsSuccessResponse(documents: const [
      Document(
        id: "documentId",
        documentType: DocumentType.creditCardContract,
        fileType: "PDF",
        fileSize: "1.2MB",
      )
    ]);
  }
}

class FakeFailingDocumentsService extends DocumentsService {
  @override
  Future<DocumentsServiceResponse> getPostboxDocuments({required User user}) async {
    return DocumentsServiceErrorResponse(errorType: DocumentsErrorType.unknown);
  }
}

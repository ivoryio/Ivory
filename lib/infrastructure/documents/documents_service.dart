import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/documents/document.dart';
import 'package:solarisdemo/models/documents/documents_error_type.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';
import 'package:solarisdemo/utilities/format.dart';

class DocumentsService extends ApiService {
  DocumentsService({super.user});

  Future<DocumentsServiceResponse> getPostboxDocuments({required User user}) async {
    this.user = user;
    try {
      final response = await get('/postbox_items');

      final documents = (response.data as List)
          .map(
            (document) => Document(
              id: document['id'],
              documentType: _getDocumentType(document['document_type']),
              fileType: _getFileType(document['document_content_type']),
              fileSize: Format.fileSize(document['document_size']),
            ),
          )
          .toList();

      return GetDocumentsSuccessResponse(documents: documents);
    } catch (error) {
      return DocumentsServiceErrorResponse(errorType: DocumentsErrorType.unknown);
    }
  }
}

String _getFileType(String fileType) {
  if (fileType == 'application/pdf') {
    return "PDF";
  }

  return "";
}

DocumentType _getDocumentType(String documentType) {
  switch (documentType) {
    case 'CREDIT_CARD_CONTRACT':
      return DocumentType.creditCardContract;
    case 'CREDIT_CARD_SECCI':
      return DocumentType.creditCardSecci;
    default:
      return DocumentType.unknown;
  }
}

abstract class DocumentsServiceResponse extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetDocumentsSuccessResponse extends DocumentsServiceResponse {
  final List<Document> documents;

  GetDocumentsSuccessResponse({required this.documents});

  @override
  List<Object?> get props => [documents];
}

class DocumentsServiceErrorResponse extends DocumentsServiceResponse {
  final DocumentsErrorType errorType;

  DocumentsServiceErrorResponse({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}

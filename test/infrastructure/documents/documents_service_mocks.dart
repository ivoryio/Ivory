import 'package:http/http.dart';
import 'package:solarisdemo/models/documents/document.dart';

class MockDocuments {
  static const creditCardContract = Document(
    id: "creditCardContractId",
    documentType: DocumentType.creditCardContract,
    fileType: "application/pdf",
    fileSize: 1024,
  );

  static const creditCardSecci = Document(
    id: "creditCardSecciId",
    documentType: DocumentType.creditCardSecci,
    fileType: "application/pdf",
    fileSize: 2048,
  );

  static const unknownDocument = Document(
    id: "unknownDocumentId",
    documentType: DocumentType.unknown,
    fileType: "application/pdf",
    fileSize: 1024,
  );
}

class DocumentsHttpResponse {
  static Response emptyList = Response("[]", 200);

  static Response invalid = Response("{}", 200);

  static Response creditCardContractAndSecci = Response(
    '''[
      {
        "id": "creditCardContractId",
        "document_type": "CREDIT_CARD_CONTRACT",
        "document_content_type": "application/pdf",
        "document_size": 1024
      },
      {
        "id": "creditCardSecciId",
        "document_type": "CREDIT_CARD_SECCI",
        "document_content_type": "application/pdf",
        "document_size": 2048
      }
    ]''',
    200,
  );

  static Response creditCardContract = Response(
    '''[{
      "id": "creditCardContractId",
      "document_type": "CREDIT_CARD_CONTRACT",
      "document_content_type": "application/pdf",
      "document_size": 1024
    }]''',
    200,
  );

  static Response unknownDocument = Response(
    '''[{
      "id": "unknownDocumentId",
      "document_type": "UNKNOWN_DOCUMENT",
      "document_content_type": "application/pdf",
      "document_size": 1024
    }]''',
    200,
  );
}

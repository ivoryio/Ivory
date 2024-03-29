import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/documents/document.dart';
import 'package:solarisdemo/models/documents/documents_error_type.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class DocumentsService extends ApiService {
  DocumentsService({super.user});

  Future<DocumentsServiceResponse> getPostboxDocuments({required User user}) async {
    this.user = user;

    try {
      final response = await get('/postbox_items');

      final documents = (response as List)
          .map(
            (document) => Document(
              id: document['id'],
              documentType: DocumentTypeParser.parse(document['document_type']),
              fileType: document['document_content_type'] ?? '',
              fileSize: document['document_size'] ?? 0,
            ),
          )
          .toList();

      return GetDocumentsSuccessResponse(documents: documents);
    } catch (error) {
      return DocumentsServiceErrorResponse(errorType: DocumentsErrorType.unknown);
    }
  }

  Future<DocumentsServiceResponse> downloadDocument({
    required User user,
    required Document document,
    required DocumentDownloadLocation downloadLocation,
  }) async {
    this.user = user;

    try {
      final Map<DocumentDownloadLocation, String> downloadLocations = {
        DocumentDownloadLocation.postbox: '/postbox_items/${document.id}',
        DocumentDownloadLocation.person: '/person/documents/${document.id}',
      };

      final response = await downloadFile(downloadLocations[downloadLocation]!);

      return DownloadDocumentSuccessResponse(document: document, file: response);
    } catch (error) {
      return DocumentsServiceErrorResponse(errorType: DocumentsErrorType.unknown);
    }
  }

  Future<DocumentsServiceResponse> confirmPostboxDocuments({
    required User user,
    required List<Document> documents,
  }) async {
    this.user = user;

    try {
      final response = await post('/postbox_items/confirmations', body: {
        'documents': documents.map((document) => document.id).toList(),
      });

      if (response['success'] != true) {
        return DocumentsServiceErrorResponse(errorType: DocumentsErrorType.unknown);
      }

      return ConfirmDocumentsSuccessResponse();
    } catch (error) {
      return DocumentsServiceErrorResponse(errorType: DocumentsErrorType.unknown);
    }
  }
}

enum DocumentDownloadLocation { postbox, person }

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

class DownloadDocumentSuccessResponse extends DocumentsServiceResponse {
  final Document document;
  final Uint8List file;

  DownloadDocumentSuccessResponse({required this.document, required this.file});

  @override
  List<Object?> get props => [document, file];
}

class ConfirmDocumentsSuccessResponse extends DocumentsServiceResponse {}

class DocumentsServiceErrorResponse extends DocumentsServiceResponse {
  final DocumentsErrorType errorType;

  DocumentsServiceErrorResponse({required this.errorType});

  @override
  List<Object?> get props => [errorType];
}

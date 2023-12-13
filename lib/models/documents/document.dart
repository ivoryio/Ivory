import 'package:equatable/equatable.dart';

class Document extends Equatable {
  final String id;
  final String fileType;
  final int fileSize;
  final DocumentType documentType;

  const Document({
    required this.id,
    required this.fileType,
    required this.fileSize,
    required this.documentType,
  });

  String get title {
    final titleMap = {
      DocumentType.creditCardContract: "Credit Card Application",
      DocumentType.creditCardSecci: "Standard European Consumer Credit Information (SECCI)",
      DocumentType.qesDocument: "Qualified Electronic Signature",
    };

    return titleMap[documentType] ?? "Unknown";
  }

  String get fileName {
    final fileNameMap = {
      DocumentType.creditCardContract: "credit_card_contract_$id",
      DocumentType.creditCardSecci: "credit_card_secci_$id",
      DocumentType.qesDocument: "qes_document_$id",
    };

    return fileNameMap[documentType] ?? id;
  }

  @override
  List<Object> get props => [id, fileType, fileSize, documentType];
}

enum DocumentType {
  creditCardContract,
  creditCardSecci,
  qesDocument,
  unknown,
}

extension DocumentTypeParser on DocumentType {
  static DocumentType parse(String documentType) {
    final documentTypeMap = {
      'CREDIT_CARD_CONTRACT': DocumentType.creditCardContract,
      'CREDIT_CARD_SECCI': DocumentType.creditCardSecci,
      'QES_DOCUMENT': DocumentType.qesDocument,
    };

    return documentTypeMap[documentType] ?? DocumentType.unknown;
  }
}

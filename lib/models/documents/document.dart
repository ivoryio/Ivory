import 'package:equatable/equatable.dart';

class Document extends Equatable {
  final String id;
  final String fileType;
  final String fileSize;
  final DocumentType documentType;

  const Document({
    required this.id,
    required this.fileType,
    required this.fileSize,
    required this.documentType,
  });

  String get title {
    switch (documentType) {
      case DocumentType.creditCardContract:
        return "Credit Card Contract";
      case DocumentType.creditCardSecci:
        return "Credit Card SECCI";
      case DocumentType.unknown:
        return "Unknown";
    }
  }

  String get fileName {
    switch (documentType) {
      case DocumentType.creditCardContract:
        return "credit_card_contract";
      case DocumentType.creditCardSecci:
        return "credit_card_secci";
      case DocumentType.unknown:
        return "unknown";
    }
  }

  @override
  List<Object> get props => [id, fileType, fileSize, documentType];
}

enum DocumentType {
  creditCardContract,
  creditCardSecci,
  unknown,
}

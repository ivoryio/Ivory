import 'package:equatable/equatable.dart';

class Document extends Equatable {
  final String id;
  final String size;
  final String fileType;
  final String documentId;
  final DocumentType documentType;

  const Document({
    required this.id,
    required this.size,
    required this.fileType,
    required this.documentId,
    required this.documentType,
  });

  @override
  List<Object> get props => [id, size, fileType, documentId, documentType];
}

enum DocumentType {
  creditCardContract,
  creditCardSecci,
}

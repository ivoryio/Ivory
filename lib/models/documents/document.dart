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

  @override
  List<Object> get props => [id, fileType, fileSize, documentType];
}

enum DocumentType {
  creditCardContract,
  creditCardSecci,
  unknown,
}

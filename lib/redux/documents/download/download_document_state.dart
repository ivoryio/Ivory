import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/documents/document.dart';
import 'package:solarisdemo/models/documents/documents_error_type.dart';

abstract class DownloadDocumentState extends Equatable {
  @override
  List<Object> get props => [];
}

class DownloadDocumentInitialState extends DownloadDocumentState {}

class DocumentDownloadingState extends DownloadDocumentState {
  final Document document;

  DocumentDownloadingState({required this.document});

  @override
  List<Object> get props => [document];
}

class DocumentDownloadedState extends DownloadDocumentState {}

class DocumentDownloadErrorState extends DownloadDocumentState {
  final DocumentsErrorType errorType;

  DocumentDownloadErrorState({required this.errorType});

  @override
  List<Object> get props => [errorType];
}

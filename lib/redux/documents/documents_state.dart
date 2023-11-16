import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/documents/document.dart';
import 'package:solarisdemo/models/documents/documents_error_type.dart';

abstract class DocumentsState extends Equatable {
  @override
  List<Object> get props => [];
}

class DocumentsInitialLoadingState extends DocumentsState {}

class DocumentsFetchedState extends DocumentsState {
  final List<Document> documents;

  DocumentsFetchedState({required this.documents});

  @override
  List<Object> get props => [documents];
}

class DocumentsErrorState extends DocumentsState {
  final DocumentsErrorType errorType;

  DocumentsErrorState({required this.errorType});

  @override
  List<Object> get props => [errorType];
}

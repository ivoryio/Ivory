import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/documents/document.dart';

abstract class DocumentsState extends Equatable {
  @override
  List<Object> get props => [];
}

class DocumentsInitialState extends DocumentsState {}

class DocumentsLoadingState extends DocumentsState {}

class DocumentsFetchedState extends DocumentsState {
  final List<Document> documents;

  DocumentsFetchedState({required this.documents});

  @override
  List<Object> get props => [documents];
}

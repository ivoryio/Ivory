import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/documents/documents_error_type.dart';

abstract class ConfirmDocumentsState extends Equatable {
  @override
  List<Object> get props => [];
}

class ConfirmDocumentsInitialState extends ConfirmDocumentsState {}

class ConfirmDocumentsLoadingState extends ConfirmDocumentsState {}

class ConfirmedDocumentsState extends ConfirmDocumentsState {}

class ConfirmDocumentsErrorState extends ConfirmDocumentsState {
  final DocumentsErrorType errorType;

  ConfirmDocumentsErrorState({required this.errorType});

  @override
  List<Object> get props => [errorType];
}

import 'package:equatable/equatable.dart';

abstract class DocumentsState extends Equatable {
  @override
  List<Object> get props => [];
}

class DocumentsInitialState extends DocumentsState {}

class DocumentsLoadingState extends DocumentsState {}

class DocumentsFetchedState extends DocumentsState {
  DocumentsFetchedState();

  @override
  List<Object> get props => [];
}

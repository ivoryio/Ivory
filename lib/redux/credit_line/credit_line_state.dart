import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/credit_line.dart';

abstract class CreditLineState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreditLineInitialState extends CreditLineState {}

class CreditLineLoadingState extends CreditLineState {
  CreditLineLoadingState();
}

class CreditLineErrorState extends CreditLineState {}

class CreditLineFetchedState extends CreditLineState {
  final CreditLine creditLine;

  CreditLineFetchedState(this.creditLine);

  @override
  List<Object?> get props => [creditLine];
}

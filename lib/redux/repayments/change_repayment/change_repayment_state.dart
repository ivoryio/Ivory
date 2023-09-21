import 'package:equatable/equatable.dart';

abstract class ChangeRepaymentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChangeRepaymentInitialState extends ChangeRepaymentState {}

class ChangeRepaymentLoadingState extends ChangeRepaymentState {}

class ChangeRepaymentErrorState extends ChangeRepaymentState {}

class ChangeRepaymentUpdateState extends ChangeRepaymentState {
  final double fixedRate;
  ChangeRepaymentUpdateState(this.fixedRate);

  @override
  List<Object?> get props => [fixedRate];
}

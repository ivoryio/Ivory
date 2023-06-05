part of 'splitpay_cubit.dart';

abstract class SplitpayState extends Equatable {
  final Transaction transaction;

  const SplitpayState({required this.transaction});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class SplitpayInitialState extends SplitpayState {
  const SplitpayInitialState({required Transaction transaction})
      : super(transaction: transaction);
}

class SplitpaySelectedState extends SplitpayState {
  const SplitpaySelectedState({required Transaction transaction})
      : super(transaction: transaction);
}

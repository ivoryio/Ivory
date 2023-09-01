part of 'splitpay_cubit.dart';

abstract class SplitpayState extends Equatable {
  final Transaction transaction;
  final SplitpayInfo? splitpayInfo;

  const SplitpayState({
    required this.transaction,
    this.splitpayInfo,
  });

  @override
  List<Object?> get props => throw UnimplementedError();
}

class SplitpayInitialState extends SplitpayState {
  const SplitpayInitialState({
    required Transaction transaction,
  }) : super(
          transaction: transaction,
        );
}

class SplitpaySelectedState extends SplitpayState {
  const SplitpaySelectedState({
    required Transaction transaction,
    required SplitpayInfo splitpayInfo,
  }) : super(
          transaction: transaction,
          splitpayInfo: splitpayInfo,
        );
}

class SplitpayInfo {
  late int nrOfMonths;
  late double monthlyAmount;
  late double totalAmount;

  SplitpayInfo(Transaction transaction, int numberOfMonths) {
    nrOfMonths = numberOfMonths;
    totalAmount = _calculateTotalAmount(
      transaction.amount!.value,
      numberOfMonths,
    );
    monthlyAmount = _calculateMonthlyAmount(
      totalAmount,
      numberOfMonths,
    );
  }

  _calculateTotalAmount(num originalAmount, int nrOfMonths) {
    num totalAmount = 0;
    switch (nrOfMonths) {
      case 3:
        totalAmount = originalAmount.abs() * 1.0765;
        break;
      case 6:
        totalAmount = originalAmount.abs() * 1.1321;
        break;
      case 9:
        totalAmount = originalAmount.abs() * 1.2132;
        break;
      default:
        totalAmount = originalAmount.abs();
        break;
    }
    return (totalAmount * 100).roundToDouble() / 100;
  }

  _calculateMonthlyAmount(double totalAmount, int nrOfMonths) {
    double monthlyAmount = totalAmount.abs() / nrOfMonths;
    return (monthlyAmount * 100).roundToDouble() / 100;
  }
}

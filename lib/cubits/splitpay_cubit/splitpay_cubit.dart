import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/transaction_model.dart';
part 'splitpay_state.dart';

class SplitpayCubit extends Cubit<SplitpayState> {
  SplitpayCubit({
    required Transaction transaction,
  }) : super(SplitpayInitialState(
          transaction: transaction,
        ));

  void setTransaction(
    Transaction transaction,
  ) {
    emit(SplitpayInitialState(
      transaction: transaction,
    ));
  }

  void setSelected(
    Transaction transaction,
    SplitpayInfo splitpayInfo,
  ) {
    emit(SplitpaySelectedState(
      transaction: transaction,
      splitpayInfo: splitpayInfo,
    ));
  }
}

import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/credit_line.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_state.dart';

class CreditLinePresenter {
  static CreditLineViewModel presentCreditLine({required CreditLineState creditLineState}) {
    if (creditLineState is CreditLineLoadingState) {
      return CreditLineLoadingViewModel();
    } else if (creditLineState is CreditLineErrorState) {
      return CreditLineErrorViewModel();
    } else if (creditLineState is CreditLineFetchedState) {
      return CreditLineFetchedViewModel(
        creditLine: creditLineState.creditLine,
      );
    }

    return CreditLineInitialViewModel();
  }
}

abstract class CreditLineViewModel extends Equatable {
  const CreditLineViewModel();

  @override
  List<Object?> get props => [];
}

class CreditLineInitialViewModel extends CreditLineViewModel {}

class CreditLineLoadingViewModel extends CreditLineViewModel {}

class CreditLineErrorViewModel extends CreditLineViewModel {}

class CreditLineFetchedViewModel extends CreditLineViewModel {
  final CreditLine creditLine;
  const CreditLineFetchedViewModel({required this.creditLine});

  @override
  List<Object?> get props => [creditLine];
}

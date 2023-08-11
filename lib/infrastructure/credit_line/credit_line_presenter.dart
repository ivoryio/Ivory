import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/credit_line.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_state.dart';

class CreditLinePresenter {
  static CreditLineViewModel presentCreditLine(
      {required CreditLineState creditLineState, required AuthenticatedUser user}) {
    if (creditLineState is CreditLineLoadingState) {
      return CreditLineLoadingViewModel();
    } else if (creditLineState is CreditLineErrorState) {
      return CreditLineErrorViewModel();
    } else if (creditLineState is CreditLineFetchedState) {
      return CreditLineFetchedViewModel(
        creditLine: creditLineState.creditLine,
        ownerName: user.person.firstName!,
        iban: user.personAccount.iban ?? '',
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
  final String ownerName;
  final String iban;

  const CreditLineFetchedViewModel({
    required this.creditLine,
    required this.ownerName,
    required this.iban,
  });

  @override
  List<Object?> get props => [creditLine, ownerName, iban];
}

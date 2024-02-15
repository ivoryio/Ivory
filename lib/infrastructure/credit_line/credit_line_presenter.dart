import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/credit_line.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/credit_line/credit_line_state.dart';
import 'package:solarisdemo/redux/repayments/more_credit/more_credit_state.dart';

class RepaymentsPresenter {
  static CreditLineViewModel presentCreditLine({
    required CreditLineState creditLineState,
    required MoreCreditState moreCreditState,
    required AuthenticatedUser user,
  }) {
    if (creditLineState is CreditLineLoadingState || moreCreditState is MoreCreditLoadingState) {
      return CreditLineLoadingViewModel();
    } else if (creditLineState is CreditLineErrorState || moreCreditState is MoreCreditErrorState) {
      return CreditLineErrorViewModel();
    } else if (creditLineState is CreditLineFetchedState && moreCreditState is MoreCreditFetchedState) {
      return CreditLineFetchedViewModel(
        creditLine: creditLineState.creditLine,
        waitlist: moreCreditState.waitlist,
        ownerName: user.person.firstName,
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
  final bool waitlist;

  const CreditLineFetchedViewModel({
    required this.creditLine,
    required this.ownerName,
    required this.iban,
    required this.waitlist,
  });

  @override
  List<Object?> get props => [creditLine, ownerName, iban, waitlist];
}

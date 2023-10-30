import 'package:equatable/equatable.dart';
import 'package:solarisdemo/redux/repayments/more_credit/more_credit_state.dart';

class MoreCreditPresenter {
  static MoreCreditViewModel presentMoreCredit({
    required MoreCreditState moreCreditState,
  }) {
    if (moreCreditState is MoreCreditLoadingState) {
      return MoreCreditLoadingViewModel();
    } else if (moreCreditState is MoreCreditErrorState) {
      return MoreCreditErrorViewModel();
    } else if (moreCreditState is MoreCreditFetchedState) {
      return MoreCreditFetchedViewModel(
        waitlist: moreCreditState.waitlist,
      );
    }

    return MoreCreditInitialViewModel();
  }
}

abstract class MoreCreditViewModel extends Equatable {
  const MoreCreditViewModel();

  @override
  List<Object?> get props => [];
}

class MoreCreditInitialViewModel extends MoreCreditViewModel {}

class MoreCreditLoadingViewModel extends MoreCreditViewModel {}

class MoreCreditErrorViewModel extends MoreCreditViewModel {}

class MoreCreditFetchedViewModel extends MoreCreditViewModel {
  final bool waitlist;

  const MoreCreditFetchedViewModel({
    required this.waitlist,
  });

  @override
  List<Object?> get props => [waitlist];
}

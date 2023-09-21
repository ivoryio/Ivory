import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/bank_card/bank_card_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_action.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/cards_cubit/cards_cubit.dart';
import '../../models/bank_card.dart';
import '../../models/user.dart';
import '../../utilities/constants.dart';
import '../../widgets/button.dart';
import '../../widgets/card_widget.dart';
import '../../widgets/empty_list_message.dart';
import 'card_actions.dart';

class BankCardsScreen extends StatelessWidget {
  static const routeName = "/cardsScreen";

  const BankCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;

    return StoreConnector<AppState, BankCardViewModel>(
      onInit: (store) {
        store.dispatch(GetBankCardsCommandAction(user: user));
      },
      converter: (store) {
        return BankCardPresenter.presentBankCard(
          bankCardState: store.state.bankCardState,
          user: user,
        );
      },
      builder: (context, viewModel) {
        if (viewModel is BankCardLoadingViewModel && viewModel.bankCards == null) {
          return const GenericLoadingScreen(title: "Cards");
        }
        if (viewModel is BankCardsFetchedViewModel) {
          return ScreenScaffold(
            body: Column(
              children: [
                const AppToolbar(
                  title: "Cards",
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: _Content(cards: viewModel.bankCards!),
                  ),
                ),
              ],
            ),
          );
        }
        return const GenericErrorScreen(
          title: "Cards",
          message: "Cards could not be loaded",
        );
      },
    );

    // return BlocProvider.value(
    //   value: BankCardsCubit(cardsService: BankCardsService(user: user.cognito))..getCards(),
    //   child: BlocBuilder<BankCardsCubit, BankCardsState>(
    //     builder: (context, state) {
    //       if (state is BankCardsLoading) {
    //         return const GenericLoadingScreen(title: "Cards");
    //       }

    //       if (state is BankCardsLoaded) {
    //         return ScreenScaffold(
    //           body: Column(
    //             children: [
    //               const AppToolbar(
    //                 title: "Cards",
    //               ),
    //               Expanded(
    //                 child: SingleChildScrollView(
    //                   child: _Content(cards: state.cards),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         );
    //       }

    //       if (state is BankCardsError) {
    //         return GenericErrorScreen(
    //           title: "Cards",
    //           message: state.message,
    //         );
    //       }

    //       return const GenericErrorScreen(
    //         title: "Cards",
    //         message: "Cards could not be loaded",
    //       );
    //     },
    //   ),
    // );
  }
}

class _Content extends StatelessWidget {
  final List<BankCard> cards;

  const _Content({required this.cards});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CardSlider(cards: cards),
        const SizedBox(height: 4),
        if (cards.isNotEmpty) CardActions(initialCardId: cards[0].id),
      ],
    );
  }
}

class _CardSlider extends StatelessWidget {
  final List<BankCard> cards;

  const _CardSlider({required this.cards});

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
        child: const Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50, bottom: 16),
              child: TextMessageWithCircularImage(
                title: "No cards added",
                message: "There are no cards yet. Order a card here.",
              ),
            ),
            _OrderCardButton(),
          ],
        ),
      );
    }

    final pageController = PageController(viewportFraction: 0.85);
    return Column(
      children: [
        SizedBox(
          height: 188,
          child: PageView.builder(
            controller: pageController,
            clipBehavior: Clip.none,
            itemCount: cards.length,
            onPageChanged: (i) => StoreProvider.of<AppState>(context).dispatch(GetBankCardCommandAction(
              user: context.read<AuthCubit>().state.user!,
              cardId: cards[i].id,
            )),
            itemBuilder: (context, i) {
              BankCard card = cards[i];

              String cardNumber = card.representation?.maskedPan ?? emptyStringValue;
              String cardHolder = card.representation?.line2 ?? emptyStringValue;
              String cardExpiry = card.representation?.formattedExpirationDate ?? emptyStringValue;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GestureDetector(
                  onTap: () => pageController.animateToPage(
                    i,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: BankCardWidget(
                    cardNumber: cardNumber,
                    cardHolder: cardHolder,
                    cardExpiry: cardExpiry,
                    isViewable: false,
                    isFrozen: card.status == BankCardStatus.BLOCKED,
                    cardType: card.type.toString().toLowerCase().contains('virtual') ? 'Virtual card' : 'Physical card',
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: SmoothPageIndicator(
            controller: pageController,
            count: cards.length,
            effect: SlideEffect(
              dotWidth: 8,
              dotHeight: 4,
              activeDotColor: ClientConfig.getColorScheme().secondary,
              dotColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.23),
            ),
          ),
        ),
      ],
    );
  }
}

class _OrderCardButton extends StatelessWidget {
  const _OrderCardButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Button(
        text: "Get new card",
        onPressed: () => addNewCard(context),
        color: ClientConfig.getColorScheme().tertiary,
        textColor: ClientConfig.getColorScheme().surface,
        textStyle: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
      ),
    );
  }
}

void addNewCard(BuildContext context) {
  final user = context.read<AuthCubit>().state.user!;
  CreateBankCard card = CreateBankCard(
    user.person.firstName!,
    user.person.lastName!,
    BankCardType.VIRTUAL_VISA_CREDIT,
    user.personAccount.businessId ?? '',
  );
  context.read<BankCardsCubit>().createCard(card);
}

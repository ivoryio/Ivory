import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/screens/wallet/card_details_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/cards_cubit/cards_cubit.dart';
import '../../models/bank_card.dart';
import '../../models/user.dart';
import '../../services/card_service.dart';
import '../../utilities/constants.dart';
import '../../widgets/button.dart';
import '../../widgets/card_widget.dart';
import '../../widgets/empty_list_message.dart';
import '../../widgets/spaced_column.dart';
import '../../widgets/tab_view.dart';

class BankCardsScreen extends StatelessWidget {
  static const routeName = "/cardsScreen";

  const BankCardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;
    return BlocProvider.value(
      value: BankCardsCubit(cardsService: BankCardsService(user: user.cognito))
        ..getCards(),
      child: BlocBuilder<BankCardsCubit, BankCardsState>(
        builder: (context, state) {
          if (state is BankCardsLoading) {
            return const GenericLoadingScreen(title: "Cards");
          }

          if (state is BankCardsLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const AppToolbar(title: "Cards"),
                  Expanded(
                    child: WalletScreenBody(
                      physicalCards: state.physicalCards,
                      virtualCards: state.virtualCards,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is BankCardsError) {
            return GenericErrorScreen(
              title: "Cards",
              message: state.message,
            );
          }

          return const GenericErrorScreen(
            title: "Cards",
            message: "Cards could not be loaded",
          );
        },
      ),
    );
  }
}

class WalletScreenBody extends StatelessWidget {
  final List<BankCard> physicalCards;
  final List<BankCard> virtualCards;

  const WalletScreenBody({
    super.key,
    required this.physicalCards,
    required this.virtualCards,
  });

  @override
  Widget build(BuildContext context) {
    return TabView(
      tabs: [
        TabViewItem(
          text: "Physical",
          child: Expanded(
              child:
                  SingleChildScrollView(child: CardList(cards: physicalCards))),
        ),
        TabViewItem(
          text: "Virtual",
          child: Expanded(
              child:
                  SingleChildScrollView(child: CardList(cards: virtualCards))),
        ),
      ],
    );
  }
}

class CardList extends StatelessWidget {
  final List<BankCard> cards;

  const CardList({
    super.key,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: SpacedColumn(
        space: 15,
        children: [
          if (cards.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 50, bottom: 10),
              child: TextMessageWithCircularImage(
                title: "No cards added",
                message: "There are no cards yet. Command a card here.",
              ),
            ),
          if (cards.isNotEmpty)
            ListView.separated(
              shrinkWrap: true,
              itemCount: cards.length,
              physics: const ClampingScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                BankCard card = cards[index];

                String cardNumber =
                    card.representation?.maskedPan ?? emptyStringValue;
                String cardHolder =
                    card.representation?.line2 ?? emptyStringValue;
                String cardExpiry =
                    card.representation?.formattedExpirationDate ??
                        emptyStringValue;

                return GestureDetector(
                  onTap: card.status == BankCardStatus.ACTIVE ||
                          card.status == BankCardStatus.INACTIVE
                      ? () {
                          Navigator.pushNamed(
                              context, BankCardDetailsScreen.routeName,
                              arguments: CardDetailsScreenParams(card: card));
                        }
                      : null,
                  child: BankCardWidget(
                    cardNumber: cardNumber,
                    cardHolder: cardHolder,
                    cardExpiry: cardExpiry,
                  ),
                );
              },
            ),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: "Get new card",
                  onPressed: () {
                    CreateBankCard card = CreateBankCard(
                      user.person.firstName!,
                      user.person.lastName!,
                      BankCardType.VIRTUAL_VISA_CREDIT,
                      user.personAccount.businessId ?? '',
                    );
                    context.read<BankCardsCubit>().createCard(card);
                  },
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

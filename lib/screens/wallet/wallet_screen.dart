import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/cards_cubit/cards_cubit.dart';
import '../../models/bank_card.dart';
import '../../models/user.dart';
import '../../router/routing_constants.dart';
import '../../services/card_service.dart';
import '../../utilities/constants.dart';
import '../../widgets/button.dart';
import '../../widgets/empty_list_message.dart';
import '../../widgets/screen.dart';
import '../../widgets/tab_view.dart';
import '../../themes/default_theme.dart';
import '../../widgets/spaced_column.dart';
import '../../widgets/card_widget.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;
    return BlocProvider.value(
      value: BankCardsCubit(cardsService: BankCardsService(user: user.cognito))
        ..getCards(),
      child: BlocBuilder<BankCardsCubit, BankCardsState>(
        builder: (context, state) {
          if (state is BankCardsLoading) {
            return const LoadingScreen(title: "Wallet");
          }

          if (state is BankCardsLoaded) {
            return Screen(
              title: "Wallet",
              child: WalletScreenBody(
                physicalCards: state.physicalCards,
                virtualCards: state.virtualCards,
              ),
            );
          }

          if (state is BankCardsError) {
            return ErrorScreen(
              title: "Wallet",
              message: state.message,
            );
          }

          return const ErrorScreen(
            title: "Wallet",
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: defaultScreenHorizontalPadding,
      ),
      child: TabView(
        tabs: [
          TabViewItem(
            text: "Physical",
            child: CardList(cards: physicalCards),
          ),
          TabViewItem(
            text: "Virtual",
            child: CardList(cards: virtualCards),
          ),
        ],
      ),
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
                    card.representation?.line1 ?? emptyStringValue;
                String cardExpiry =
                    card.representation?.formattedExpirationDate ??
                        emptyStringValue;

                return GestureDetector(
                  onTap: () {
                    context.push(
                      cardDetailsRoute.path,
                      extra: card,
                    );
                  },
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
                      BankCardType
                          .VIRTUAL_VISA_CREDIT, //to be changed for production
                      user.personAccount.businessId ?? '',
                    );
                    context.read<BankCardsCubit>().createVirtualCard(card);
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

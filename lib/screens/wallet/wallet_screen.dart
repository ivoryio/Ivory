import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/debit_cards_cubit/debit_cards_cubit.dart';
import '../../models/debit_card.dart';
import '../../models/user.dart';
import '../../router/routing_constants.dart';
import '../../services/debit_card_service.dart';
import '../../utilities/constants.dart';
import '../../widgets/button.dart';
import '../../widgets/empty_list_message.dart';
import '../../widgets/screen.dart';
import '../../widgets/tab_view.dart';
import '../../themes/default_theme.dart';
import '../../widgets/spaced_column.dart';
import '../../widgets/debit_card_widget.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;
    return BlocProvider.value(
      value: DebitCardsCubit(
          debitCardsService: DebitCardsService(user: user.cognito))
        ..getDebitCards(),
      child: BlocBuilder<DebitCardsCubit, DebitCardsState>(
        builder: (context, state) {
          if (state is DebitCardsLoading) {
            return const LoadingScreen(title: "Wallet");
          }

          if (state is DebitCardsLoaded) {
            return Screen(
              title: "Wallet",
              child: WalletScreenBody(
                physicalCards: state.physicalCards,
                virtualCards: state.virtualCards,
              ),
            );
          }

          if (state is DebitCardsError) {
            return ErrorScreen(
              title: "Wallet",
              message: state.message,
            );
          }

          return const ErrorScreen(
            title: "Wallet",
            message: "Debit cards could not be loaded",
          );
        },
      ),
    );
  }
}

class WalletScreenBody extends StatelessWidget {
  final List<DebitCard> physicalCards;
  final List<DebitCard> virtualCards;

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
  final List<DebitCard> cards;

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
                DebitCard card = cards[index];

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
                  child: DebitCardWidget(
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
                    CreateDebitCard card = CreateDebitCard(
                      user.person.firstName!,
                      user.person.lastName!,
                      DebitCardType
                          .VIRTUAL_VISA_BUSINESS_DEBIT, //to be changed for production
                      user.personAccount.businessId ?? '',
                    );
                    context
                        .read<DebitCardsCubit>()
                        .createVirtualDebitCard(card);
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

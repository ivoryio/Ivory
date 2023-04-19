import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/cubits/cubit/debit_cards_cubit.dart';
import 'package:solarisdemo/widgets/empty_list_message.dart';

import '../../models/debit_card.dart';
import '../../widgets/button.dart';
import '../../widgets/screen.dart';
import '../../widgets/tab_view.dart';
import '../../themes/default_theme.dart';
import '../../widgets/spaced_column.dart';
import '../../widgets/debit_card_widget.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: DebitCardsCubit()..getDebitCards(),
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
            child: PhysicalCardsList(cards: physicalCards),
          ),
          const TabViewItem(
            text: "Virtual",
            child: VirtualCardsList(),
          ),
        ],
      ),
    );
  }
}

class PhysicalCardsList extends StatelessWidget {
  final List<DebitCard> cards;

  const PhysicalCardsList({
    super.key,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: SpacedColumn(
        space: 15,
        children: [
          if (cards.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 50, bottom: 10),
              child: EmptyListMessage(
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

                String cardNumber = card.representation?.maskedPan ?? "";
                String cardHolder = card.representation?.line1 ?? "";
                String cardExpiry =
                    card.representation?.formattedExpirationDate ?? "";

                return DebitCardWidget(
                  cardNumber: cardNumber,
                  cardHolder: cardHolder,
                  cardExpiry: cardExpiry,
                );
              },
            ),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  text: "Get new card",
                  onPressed: () {},
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

class VirtualCardsList extends StatelessWidget {
  const VirtualCardsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text("Virtual Card"),
      ],
    );
  }
}

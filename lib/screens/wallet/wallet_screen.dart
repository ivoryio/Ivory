import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/cubits/cubit/credit_cards_cubit.dart';
import 'package:solarisdemo/widgets/empty_list_message.dart';

import '../../models/credit_card.dart';
import '../../widgets/button.dart';
import '../../widgets/screen.dart';
import '../../widgets/tab_view.dart';
import '../../themes/default_theme.dart';
import '../../widgets/spaced_column.dart';
import '../../widgets/credit_card_widget.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: CreditCardsCubit()..getCreditsCards(),
      child: BlocBuilder<CreditCardsCubit, CreditCardsState>(
        builder: (context, state) {
          if (state is CreditCardsLoading) {
            return const LoadingScreen(title: "Wallet");
          }

          if (state is CreditCardsLoaded) {
            return Screen(
              title: "Wallet",
              child: WalletScreenBody(
                physicalCards: state.physicalCards,
                virtualCards: state.virtualCards,
              ),
            );
          }

          if (state is CreditCardsError) {
            return ErrorScreen(
              title: "Wallet",
              message: state.message,
            );
          }

          return const ErrorScreen(
            title: "Wallet",
            message: "Credit cards could not be loaded",
          );
        },
      ),
    );
  }
}

class WalletScreenBody extends StatelessWidget {
  final List<CreditCard> physicalCards;
  final List<CreditCard> virtualCards;

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
  final List<CreditCard> cards;

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
                CreditCard card = cards[index];

                String cardNumber = card.representation?.maskedPan ?? "";
                String cardHolder = card.representation?.line1 ?? "";
                String cardExpiry =
                    card.representation?.formattedExpirationDate ?? "";

                return CreditCardWidget(
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

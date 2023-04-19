import 'package:flutter/material.dart';

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
    return const Screen(
      title: "Wallet",
      child: WalletScreenBody(),
    );
  }
}

class WalletScreenBody extends StatelessWidget {
  const WalletScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultScreenHorizontalPadding),
      child: TabView(
        tabs: [
          TabViewItem(text: "Physical", child: PhysicalCardsList()),
          TabViewItem(text: "Virtual", child: VirtualCardsList()),
        ],
      ),
    );
  }
}

class PhysicalCardsList extends StatelessWidget {
  const PhysicalCardsList({super.key});

  @override
  Widget build(BuildContext context) {
    List<CreditCardWidget> cards = [
      CreditCardWidget(
        isPrimary: true,
        cardExpiry: "08/27",
        cardHolder: "John Doe",
        cardNumber: "${"*" * 12}3456",
      ),
      CreditCardWidget(
        cardExpiry: "03/22",
        cardHolder: "Jane Doe",
        cardNumber: "${"*" * 12}9876",
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: SpacedColumn(
        space: 15,
        children: [
          ListView.separated(
            shrinkWrap: true,
            itemCount: cards.length,
            physics: const ClampingScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              return cards[index];
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

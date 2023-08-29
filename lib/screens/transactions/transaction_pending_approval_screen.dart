import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/models/amount_value.dart';
import 'package:solarisdemo/models/categories/category.dart';
import 'package:solarisdemo/models/transactions/transaction_model.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/card_list_item.dart';
import 'package:solarisdemo/widgets/circular_countdown_progress_widget.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/transaction_listing_item.dart';

class TransactionPendingApprovalScreen extends StatelessWidget {
  static const routeName = '/transactionPendingApproval';

  const TransactionPendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Appbar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Row(children: [
                      Expanded(
                          child:
                              Text("Authorize your online payment", style: ClientConfig.getTextStyleScheme().heading2)),
                      const SizedBox(
                        height: 70,
                        width: 70,
                        child: CircularCountdownProgress(
                          duration: Duration(seconds: 5),
                        ),
                      )
                    ]),
                    const SizedBox(height: 24),
                    Text("Payment details", style: ClientConfig.getTextStyleScheme().labelLarge),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: TransactionListItem(
                        transaction: Transaction(
                          recipientName: "Lufthansa",
                          description: "",
                          amount: AmountValue(
                            value: 100,
                            currency: "EUR",
                            unit: "cents",
                          ),
                          category: const Category(id: "transportationAndTravel", name: "Transportation and Travel"),
                          recordedAt: DateTime.now(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text("Card details", style: ClientConfig.getTextStyleScheme().labelLarge),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CardListItem(cardNumber: "*** 4573", expiryDate: "10/27"),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: SecondaryButton(
                text: "Reject",
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: "Save",
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _Appbar extends StatelessWidget {
  const _Appbar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset("assets/icons/default/appbar_logo.svg"),
          SvgPicture.asset("assets/icons/visa_logo_gradient_bg.svg"),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/transfer/transfer_successful_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_card.dart';
import 'package:solarisdemo/widgets/ivory_switch.dart';
import 'package:solarisdemo/widgets/ivory_text_field.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class TransferReviewScreen extends StatelessWidget {
  static const routeName = "/transferReviewScreen";

  const TransferReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            title: "Review",
            padding: EdgeInsets.symmetric(
              horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                ),
                child: Column(
                  children: [
                    IvoryCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Transferring:",
                            style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(
                                  color: const Color(0xFF56555E),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "€ 1,000.00",
                            style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                                  color: Colors.black,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "To:",
                            style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(
                                  color: const Color(0xFF56555E),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Reference account",
                            style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                                  color: Colors.black,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Add note (optional)",
                        style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(
                              color: const Color(0xFF56555E),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const IvoryTextField(
                      minLines: 4,
                      placeholder: "Add note",
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          color: Color(0xFFCC0000),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            "Schedule transfer",
                            style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(color: Colors.black),
                          ),
                        ),
                        const SizedBox(width: 16),
                        IvorySwitch(
                          onToggle: (value) => print("Schedule transfer toggle: $value"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            ),
            child: PrimaryButton(
              text: "Sign & confirm",
              onPressed: () => Navigator.pushNamed(context, TransferSuccessfulScreen.routeName),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

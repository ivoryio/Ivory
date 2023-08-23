import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/screens/transfer/transfer_review_screen.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/currency_text_field.dart';
import 'package:solarisdemo/widgets/ivory_card.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class TransferScreen extends StatefulWidget {
  static const routeName = "/transferScreen";

  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  late AuthenticatedUser user;
  String? _errorText;
  bool _canContinue = false;
  final amountController = TextEditingController();

  void onTapNext() {
    FocusScope.of(context).unfocus();
    Navigator.pushNamed(context, TransferReviewScreen.routeName);
  }

  @override
  void initState() {
    super.initState();

    user = context.read<AuthCubit>().state.user!;

    amountController.addListener(() {
      setState(() {
        final value = double.tryParse(amountController.text) ?? 0;
        final balance = user.personAccount.availableBalance!.value;

        if (value > balance) {
          _errorText = "Insufficient funds";
          _canContinue = false;
        } else if (value > 0) {
          _errorText = null;
          _canContinue = true;
        } else {
          _errorText = null;
          _canContinue = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            title: "Transfer",
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
                    _buildCard(
                      title: "Porsche account",
                      iban: user.personAccount.iban!,
                      balance: user.personAccount.availableBalance!.value,
                      isReference: true,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.arrow_downward),
                    ),
                    _buildCard(
                      title: "Reference account",
                      iban: "DE12345678901234567890",
                      bankName: "Deutsche Bank",
                    ),
                    const SizedBox(height: 32),
                    Text(
                      "Enter transfer amount",
                      style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(
                            color: _errorText != null ? Colors.red : Color(0xFF56555E),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    CurrencyTextField(
                      controller: amountController,
                      error: _errorText != null,
                    ),
                    if (_errorText != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _errorText!,
                        style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                    const SizedBox(height: 40),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        "Want to top up your Porsche account?",
                        style: ClientConfig.getTextStyleScheme()
                            .bodyLargeRegularBold
                            .copyWith(color: const Color(0xFF406FE6)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              ),
              child: PrimaryButton(
                text: "Next",
                onPressed: _canContinue ? onTapNext : null,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required String iban,
    num? balance,
    String? bankName,
    bool isReference = false,
  }) {
    return IvoryCard(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Text(title, style: ClientConfig.getTextStyleScheme().heading4),
              if (balance != null) ...[
                const Spacer(),
                Text(
                  "€${balance.toStringAsFixed(2)}",
                  style: ClientConfig.getTextStyleScheme().heading4,
                ),
                Text("*", style: ClientConfig.getTextStyleScheme().heading4.copyWith(color: Colors.red)),
              ]
            ]),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  Format.iban(iban),
                  style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(color: const Color(0xFF56555E)),
                ),
                if (balance != null) ...[
                  const Spacer(),
                  Text(
                    "Balance",
                    style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(color: const Color(0xFF56555E)),
                  ),
                ]
              ],
            ),
          ),
          if (bankName != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    bankName,
                    style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(color: const Color(0xFF56555E)),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (isReference) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "*",
                      style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    TextSpan(
                      text: " You can only transfer the topped-up balance.",
                      style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(
                            color: const Color(0xFF15141E),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

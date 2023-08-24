import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/screens/transfer/transfer_review_screen.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_amount_field.dart';
import 'package:solarisdemo/widgets/ivory_card.dart';
import 'package:solarisdemo/widgets/modal.dart';
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
    Navigator.pushNamed(
      context,
      TransferReviewScreen.routeName,
      arguments: TransferReviewScreenParams(
        amount: double.parse(amountController.text),
        toAccount: "DE12345678901234567890",
      ),
    );
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
          _errorText = "Not enough balance";
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
                    _buildCard(_PorscheAccount(
                      title: "Porsche account",
                      iban: user.personAccount.iban!,
                      balance: user.personAccount.availableBalance!.value,
                    )),
                    const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(Icons.arrow_downward),
                    ),
                    _buildCard(const _ReferenceAccount(
                      title: "Reference account",
                      iban: "DE12345678901234567890",
                      bankName: "Deutsche Bank",
                    )),
                    const SizedBox(height: 32),
                    Text(
                      "Enter transfer amount",
                      style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(
                            color: _errorText != null ? Colors.red : const Color(0xFF56555E),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    IvoryAmountField(
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
                      onTap: () {
                        showBottomModal(
                          context: context,
                          title: "How to top up your Ivory account?",
                          content: _TopUpBottomSheetContent(iban: user.personAccount.iban!),
                        );
                      },
                      child: Text(
                        "Want to top up your Ivory account?",
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
              child: Button(
                color: const Color(0xFF2575FC),
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

  Widget _buildCard(_Account account) {
    return IvoryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: [
              Text(account.title, style: ClientConfig.getTextStyleScheme().heading4),
              if (account is _PorscheAccount) ...[
                const Spacer(),
                Text(
                  "€${account.balance.toStringAsFixed(2)}",
                  style: ClientConfig.getTextStyleScheme().heading4,
                ),
                Text("*", style: ClientConfig.getTextStyleScheme().heading4.copyWith(color: const Color(0xFF2575FC))),
              ]
            ]),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  Format.iban(account.iban),
                  style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(color: const Color(0xFF56555E)),
                ),
                if (account is _PorscheAccount) ...[
                  const Spacer(),
                  Text(
                    "Balance",
                    style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(color: const Color(0xFF56555E)),
                  ),
                ]
              ],
            ),
          ),
          if (account is _ReferenceAccount) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    account.bankName,
                    style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(color: const Color(0xFF56555E)),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (account is _PorscheAccount) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "*",
                      style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(
                            color: const Color(0xFF2575FC),
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

// TODO: temporary solution until we have the real data
abstract class _Account extends Equatable {
  final String title;
  final String iban;

  const _Account({
    required this.title,
    required this.iban,
  });

  @override
  List<Object?> get props => [title, iban];
}

class _PorscheAccount extends _Account {
  final num balance;

  const _PorscheAccount({
    required super.title,
    required super.iban,
    required this.balance,
  });

  @override
  List<Object?> get props => [title, iban, balance];
}

class _ReferenceAccount extends _Account {
  final String bankName;

  const _ReferenceAccount({
    required super.title,
    required super.iban,
    required this.bankName,
  });

  @override
  List<Object?> get props => [title, iban, bankName];
}

class _TopUpBottomSheetContent extends StatelessWidget {
  final String iban;

  const _TopUpBottomSheetContent({required this.iban});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(text: "Copy your Ivory IBAN below:", iban: iban),
        const SizedBox(height: 24),
        _buildRow(text: "Log into your reference bank account."),
        const SizedBox(height: 24),
        _buildRow(text: "Make a transfer to your Ivory account using the IBAN you copied."),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRow({required String text, String? iban}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check, color: Color(0xFF2575FC)),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
              if (iban != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      Format.iban(iban),
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold.copyWith(
                            color: const Color(0xFF15141E),
                          ),
                    ),
                    SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: iban));
                      },
                      child: const Icon(Icons.copy, color: Color(0xFF15141E)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

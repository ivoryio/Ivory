import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

const EURO_SYMBOL = "€";

class TransferScreen extends StatelessWidget {
  static const routeName = "/transferScreen";

  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticatedUser user = context.read<AuthCubit>().state.user!;

    return ScreenScaffold(
      body: Column(
        children: [
          const AppToolbar(title: "Transfer"),
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
                    SizedBox(height: 16),
                    Text(
                      "Enter transfer amount",
                      style:
                          ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(color: const Color(0xFF56555E)),
                    ),
                    _TransferAmountTextField(),
                  ],
                ),
              ),
            ),
          ),
          PrimaryButton(
            text: "Transfer",
            onPressed: () {},
          ),
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
    return _Card(
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

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFF8F9FA),
      ),
      child: child,
    );
  }
}

enum TransferType { person, business }

class TransferScreenParams {
  final TransferType transferType;

  const TransferScreenParams({
    required this.transferType,
  });
}

class EuroInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final valueWithoutCurrencySymbol =
        newValue.text.replaceAll(EURO_SYMBOL, '').replaceAll(RegExp(r'[^0-9.]'), '').trim();
    final textValue = RegExp(r'^\d{0,6}\.?\d{0,2}').stringMatch(valueWithoutCurrencySymbol) ?? "";
    final decimals = RegExp(r'\.(\d{0,2})').stringMatch(textValue)?.substring(1) ?? "";

    if (textValue.isEmpty) {
      return const TextEditingValue(
        text: "",
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    NumberFormat formatter = NumberFormat.currency(
      locale: "en_US",
      symbol: "€ ",
      decimalDigits: decimals.length,
    );

    final formattedValue = formatter.format(double.tryParse(textValue) ?? 0.00);

    if (textValue.endsWith(".")) {
      return TextEditingValue(
        text: "$formattedValue.",
        selection: TextSelection.collapsed(offset: formattedValue.length + 1),
      );
    }

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }

  static String format(double value) {
    return '$EURO_SYMBOL ${value.toStringAsFixed(2)}';
  }

  static double parse(String value) {
    return double.tryParse(value.replaceAll(EURO_SYMBOL, '').trim()) ?? 0.00;
  }
}

class _TransferAmountTextField extends StatelessWidget {
  const _TransferAmountTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        EuroInputFormatter(),
      ],
      textAlign: TextAlign.center,
      style: ClientConfig.getTextStyleScheme().heading1,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(bottom: 10),
        isDense: true,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFE9EAEB),
            width: 2,
          ),
        ),
        hintText: "0",
        hintStyle: ClientConfig.getTextStyleScheme().heading1.copyWith(
              color: const Color(0xFFC4C4C4),
            ),
      ),
    );
  }
}

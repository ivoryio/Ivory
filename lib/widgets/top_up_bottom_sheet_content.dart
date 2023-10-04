import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:solarisdemo/widgets/snackbar.dart';

import '../config.dart';
import '../utilities/format.dart';

class TopUpBottomSheetContent extends StatelessWidget {
  final String iban;

  const TopUpBottomSheetContent({super.key, required this.iban});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(context, text: "Copy your Ivory IBAN below:", iban: iban),
        const SizedBox(height: 24),
        _buildRow(context, text: "Log into your reference bank account."),
        const SizedBox(height: 24),
        _buildRow(context, text: "Make a transfer to your Ivory account using the IBAN you copied."),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildRow(BuildContext context, {required String text, String? iban}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check, color: ClientConfig.getColorScheme().secondary),
        const SizedBox(width: 16),
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
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Clipboard.setData(ClipboardData(text: iban));
                        showSnackbar(
                          context,
                          text: "Copied to clipboard",
                          icon: const Icon(Icons.copy, color: Colors.white),
                        );
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
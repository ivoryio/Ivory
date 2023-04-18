import 'package:flutter/widgets.dart';

import '../themes/default_theme.dart';
import 'button.dart';

class StickyBottomContent extends StatelessWidget {
  final Function onContinueCallback;
  final String? buttonText;
  const StickyBottomContent(
      {super.key,
      required this.onContinueCallback,
      this.buttonText = "Continue"});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              text: buttonText!,
              onPressed: onContinueCallback,
            ),
          ),
        ],
      ),
    );
  }
}

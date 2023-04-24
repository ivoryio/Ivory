import 'package:flutter/widgets.dart';

import '../themes/default_theme.dart';
import 'button.dart';

class StickyBottomContent extends StatefulWidget {
  final Function onContinueCallback;
  final bool buttonActive;
  final String? buttonText;

  const StickyBottomContent({
    super.key,
    this.buttonActive = true,
    this.buttonText = "Continue",
    required this.onContinueCallback,
  });

  @override
  State<StickyBottomContent> createState() => StickyBottomContentState();
}

class StickyBottomContentState extends State<StickyBottomContent> {
  bool active = true;

  bool get buttonActive => active;

  void setButtonActive() {
    setState(() {
      active = true;
    });
  }

  void setButtonDisabled() {
    setState(() {
      active = false;
    });
  }

  @override
  void initState() {
    active = widget.buttonActive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: defaultScreenPadding,
      child: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              text: widget.buttonText!,
              onPressed: active ? widget.onContinueCallback : null,
            ),
          ),
        ],
      ),
    );
  }
}

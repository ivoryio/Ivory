import 'package:flutter/material.dart';

import '../config.dart';

class PillButton extends StatelessWidget {
  final String buttonText;
  final void Function() buttonCallback;
  final Icon? icon;
  final bool active;
  const PillButton({
    super.key,
    required this.buttonText,
    required this.buttonCallback,
    this.icon,
    this.active = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: buttonCallback,
      child: SizedBox(
        // height: 25,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: active ? const Color(0xFFF8F9FA) : Colors.white,
            border: active? Border.all(
              width: 1,
              color: const Color(0xFFDFE2E6),
            ) : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                buttonText,
                style: active?
                ClientConfig.getTextStyleScheme().labelSmall:
                ClientConfig.getTextStyleScheme().labelSmall.copyWith(color: ClientConfig.getColorScheme().secondary),
              ),
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: icon!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

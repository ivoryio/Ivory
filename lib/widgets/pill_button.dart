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
            vertical: 2,
            horizontal: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: active ? const Color(0xFFE6E6E6) : Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                buttonText,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Proxima Nova",
                  fontWeight: FontWeight.w600,
                  color: ClientConfig.getColorScheme().secondary,
                ),
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

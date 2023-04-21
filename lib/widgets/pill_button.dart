import 'package:flutter/material.dart';

class PillButton extends StatelessWidget {
  final String buttonText;
  final void Function() buttonCallback;
  final Icon? icon;
  const PillButton(
      {super.key,
      required this.buttonText,
      required this.buttonCallback,
      this.icon});

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
            color: const Color(0xFFE6E6E6),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 16 / 12,
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

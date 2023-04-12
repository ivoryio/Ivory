import 'package:flutter/material.dart';

class TransferSuccessful extends StatelessWidget {
  const TransferSuccessful({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 133,
            height: 133,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF747474),
            ),
            child: const Center(
              child: Icon(
                Icons.image_outlined,
                size: 65,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          const Text(
            "Congratulations",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "The payments has been sent. You can review the payment in the Transaction section.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0XFF667085),
            ),
          ),
        ],
      ),
    );
  }
}

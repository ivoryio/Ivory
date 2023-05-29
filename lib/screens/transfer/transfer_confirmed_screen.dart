import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../router/routing_constants.dart';
import '../../themes/default_theme.dart';
import '../../widgets/screen.dart';
import '../../widgets/sticky_bottom_content.dart';

class TransferConfirmedScreen extends StatelessWidget {
  const TransferConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: '',
      hideBackButton: true,
      hideBottomNavbar: true,
      bottomStickyWidget: BottomStickyWidget(
        child: StickyBottomContent(
          buttonText: "OK, got it",
          onContinueCallback: () {
            context.go(homeRoute.path);
          },
        ),
      ),
      child: const Padding(
        padding: defaultScreenPadding,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TransferSuccessful(),
            ]),
      ),
    );
  }
}

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
            "Successful transaction",
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

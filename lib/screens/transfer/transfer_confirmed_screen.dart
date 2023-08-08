import 'package:flutter/material.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../widgets/screen.dart';
import '../../widgets/sticky_bottom_content.dart';

class TransferConfirmedScreen extends StatelessWidget {
  const TransferConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          const Spacer(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: TransferSuccessful(),
          ),
          const Spacer(),
          BottomStickyWidget(
            child: StickyBottomContent(
              buttonText: "OK, got it",
              onContinueCallback: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  HomeScreen.routeName,
                  (route) => false,
                );
              },
            ),
          )
        ],
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

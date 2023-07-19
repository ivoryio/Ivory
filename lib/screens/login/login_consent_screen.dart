import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:solarisdemo/widgets/screen.dart';

import '../../widgets/spaced_column.dart';

class GdprConsentScreen extends StatelessWidget {
  final BottomStickyWidget? bottomStickyWidget;
  const GdprConsentScreen({super.key, this.bottomStickyWidget});

  @override
  Widget build(BuildContext context) {
    return Screen(
      backButtonIcon: const Icon(
        Icons.close,
        color: Colors.black,
      ),
      customBackButtonCallback: () {
        context.pop();
      },
      title: '',
      centerTitle: true,
      hideBottomNavbar: true,
      bottomStickyWidget: bottomStickyWidget,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SpacedColumn(
                space: 20,
                children: [
                  const Text(
                    "Welcome to SolarisDemo!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SpacedColumn(
                    space: 16,
                    children: const [
                      Text(
                        'At SolarisDemo, we value your privacy and want to ensure that you have a seamless banking experience. In order to comply with the General Data Protection Regulation (GDPR), we need your consent to collect, process, and store your personal data.',
                      ),
                      Text(
                        'We need your data to provide you with a personalized banking experience, process transactions and manage your accounts securely, send you important account-related updates and notifications, conduct fraud prevention and enhance security measures, and comply with legal and regulatory requirements.',
                      ),
                      Text(
                        'Rest assured, your data will be treated with utmost care and will only be shared with authorized third parties when necessary for providing our services.',
                      ),
                      Text(
                        'By clicking "I Agree," you consent to our use of your personal data as outlined above and in our Privacy Policy. If you wish to manage your preferences, click "Manage Preferences" to customize your data sharing settings. You can change your preferences at any time in the future.',
                      ),
                      Text(
                        'Thank you for trusting SolarisDemo with your financial needs.',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static evaluate() {}
}

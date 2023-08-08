import 'package:flutter/material.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class GdprConsentScreen extends StatelessWidget {
  static const routeName = "/gdprConsentScreen";

  final void Function() onConsentCallback;

  const GdprConsentScreen({
    super.key,
    required this.onConsentCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22.0, horizontal: 24.0),
        child: Column(
          children: [
            const SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Welcome to SolarisDemo!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'At SolarisDemo, we value your privacy and want to ensure that you have a seamless banking experience. In order to comply with the General Data Protection Regulation (GDPR), we need your consent to collect, process, and store your personal data.',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'We need your data to provide you with a personalized banking experience, process transactions and manage your accounts securely, send you important account-related updates and notifications, conduct fraud prevention and enhance security measures, and comply with legal and regulatory requirements.',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Rest assured, your data will be treated with utmost care and will only be shared with authorized third parties when necessary for providing our services.',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'By clicking "I Agree," you consent to our use of your personal data as outlined above and in our Privacy Policy. If you wish to manage your preferences, click "Manage Preferences" to customize your data sharing settings. You can change your preferences at any time in the future.',
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Thank you for trusting SolarisDemo with your financial needs.',
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: "I Agree",
                    onPressed: onConsentCallback,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

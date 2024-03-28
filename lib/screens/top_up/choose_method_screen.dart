import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/screens/top_up/add_card_screen.dart';
import 'package:solarisdemo/screens/top_up/add_money_screen.dart';
import 'package:solarisdemo/screens/top_up/top_up_success_screen.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class ChooseMethodScreen extends StatefulWidget {
  static const routeName = "/chooseMethodScreen";

  const ChooseMethodScreen({Key? key}) : super(key: key);

  @override
  State<ChooseMethodScreen> createState() => _ChooseMethodScreenState();
}

class _ChooseMethodScreenState extends State<ChooseMethodScreen> {
  bool firstBoxSelected = false;
  bool secondBoxSelected = false;
  bool isButtonEnabled = false;

  void navigateToNextScreen() {
    if (firstBoxSelected) {
      Navigator.pushNamed(context, TopUpSuccessfulScreen.routeName);
    } else if (secondBoxSelected) {
      Navigator.pushNamed(context, AddCardScreen.routeName);
    }
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled = firstBoxSelected || secondBoxSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Padding(
        padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppToolbar(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Choose method',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Recommended',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            CustomBox(
              title: 'Bank transfer',
              subtitle: 'Secure transfers from card',
              icon: Icons.account_balance,
              isSelected: firstBoxSelected,
              onTap: () {
                setState(() {
                  firstBoxSelected = !firstBoxSelected;
                  secondBoxSelected = false;
                  updateButtonState();
                });
              },
            ),
            CustomBox(
              title: 'Add card',
              subtitle: 'Securely link your card',
              icon: Icons.payment,
              isSelected: secondBoxSelected,
              onTap: () {
                setState(() {
                  secondBoxSelected = !secondBoxSelected;
                  firstBoxSelected = false;
                  updateButtonState();
                });
              },
            ),
            const Spacer(),
            SizedBox( 
              width: double.infinity,
              height: 48,
              child: Button(
                text: "Next",
                disabledColor: ClientConfig.getCustomColors().neutral300,
                color: ClientConfig.getColorScheme().tertiary,
                textColor: ClientConfig.getColorScheme().surface,
                onPressed: isButtonEnabled ? navigateToNextScreen : null,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}


class CustomBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomBox({
    required this.title,
    required this.subtitle,
    required this.icon, 
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),

        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0x1F000000),
                offset: Offset(0, 2),
                blurRadius: 6,
                spreadRadius: 1,
              ),
            ],
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: isSelected ? Colors.orange : Colors.transparent,  width: 2), // Add border color when selected
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, color: Colors.orange),
                const SizedBox(width: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (isSelected)
                  const Icon(
                    Icons.check_sharp,
                    color: Colors.green,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


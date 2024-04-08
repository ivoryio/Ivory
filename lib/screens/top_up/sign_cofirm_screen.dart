


import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/utilities/format.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/ivory_switch.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/screens/top_up/top_up_success_screen.dart';

class SignAndConfirmScreen extends StatefulWidget {
  static const routeName = "/signAndCofirmScreen";

  const SignAndConfirmScreen({Key? key}) : super(key: key);

  @override
  State<SignAndConfirmScreen> createState() => _SignAndCofirmState();
}

class _SignAndCofirmState extends State<SignAndConfirmScreen> {  
  bool _canContinue = true;


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
                'Sign & confirm',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Container(
            decoration: BoxDecoration(
              color: ClientConfig.getCustomColors().neutral100,
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Adding',
                      style: TextStyle(
                        color: ClientConfig.getCustomColors().neutral500,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: Format.currencyWithSymbol(1000.000),
                            style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(color: ClientConfig.getCustomColors().neutral800, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),                
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Container(
              decoration: BoxDecoration(
                color: ClientConfig.getCustomColors().neutral100,
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From',
                        style: TextStyle(
                          color: ClientConfig.getCustomColors().neutral700,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'ING BANK',
                        style: TextStyle(
                          color: ClientConfig.getCustomColors().neutral900,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'Visa *9842',
                        style: TextStyle(
                          color: ClientConfig.getCustomColors().neutral700,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),                
                ],
              ),
            ),

            SizedBox(height: 24.0),
            ScheduleContainer(),

            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: Button(
                text: "Sign & confirm",
                disabledColor: ClientConfig.getCustomColors().neutral300,
                color: ClientConfig.getColorScheme().tertiary,
                textColor: ClientConfig.getColorScheme().surface,
                onPressed: () {
                   Navigator.pushNamed(
                      context,
                      TopUpSuccessfulScreen.routeName,   
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class ScheduleContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.calendar_month_outlined,
            color: Colors.orange,
            size: 24,
          ),
          SizedBox(width: 8),
          Text('Schedule later',
           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
           ),
           Spacer(),
           IvorySwitch(),
        ],
      ),
    );
  }
}
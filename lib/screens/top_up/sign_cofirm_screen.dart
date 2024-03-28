


import 'package:flutter/material.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class SignAndConfirmScreen extends StatefulWidget {
  static const routeName = "/signAndCofirmScreen";

  const SignAndConfirmScreen({Key? key}) : super(key: key);

  @override
  State<SignAndConfirmScreen> createState() => _SignAndCofirmState();
}

class _SignAndCofirmState extends State<SignAndConfirmScreen> {  

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
        padding: const EdgeInsets.symmetric(vertical: 8.0),

        child: Container(
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
                    Text(
                      '1000.000',
                      style: TextStyle(
                        color: ClientConfig.getCustomColors().neutral900,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),                
              ],
            ),
          ),
        ),
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
                    SizedBox(height: 8.0),
                    Text(
                      'ING BANK',
                      style: TextStyle(
                        color: ClientConfig.getCustomColors().neutral900,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.0),
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
          const SizedBox(height: 16.0),
            SizedBox( 
              width: double.infinity,
              height: 48,
              child: Button(
                text: "Sign & confirm",
                disabledColor: ClientConfig.getCustomColors().neutral300,
                color: ClientConfig.getColorScheme().tertiary,
                textColor: ClientConfig.getColorScheme().surface,
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
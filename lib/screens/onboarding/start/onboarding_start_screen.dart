import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/screen_title.dart';

class OnboardingStartScreen extends StatelessWidget {
  static const routeName = "/onboardingStartScreen";

  const OnboardingStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        children: [
          AppToolbar(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            actions: [
              SvgPicture.asset('assets/icons/default/appbar_logo.svg'),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              child: Column(
                children: [
                  ScreenTitle("It’s quick and easy!"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

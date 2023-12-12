import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/device/device_action.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../../config.dart';
import '../../../utilities/ivory_color_mapper.dart';

class AppSettingsBiometricEnabledScreen extends StatelessWidget {
  static const routeName = "/appSettingsBiometricEnabledScreen";
  const AppSettingsBiometricEnabledScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            onBackButtonPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Padding(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Biometrics enabled',
                    style: ClientConfig.getTextStyleScheme().heading1,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text('You\'re all set!'),
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: Center(
                      child: IvoryAssetWithBadge(
                        childWidget: SvgPicture(
                          SvgAssetLoader(
                            'assets/images/enable_biometrics.svg',
                            colorMapper: IvoryColorMapper(
                              baseColor: ClientConfig.getColorScheme().secondary,
                            ),
                          ),
                        ),
                        childPosition: BadgePosition.topEnd(top: -32, end: -20),
                        isSuccess: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Button(
                      text: 'Done',
                      disabledColor: ClientConfig.getCustomColors().neutral300,
                      color: ClientConfig.getColorScheme().tertiary,
                      textColor: ClientConfig.getColorScheme().surface,
                      onPressed: () {
                        Navigator.pop(context);
                        StoreProvider.of<AppState>(context).dispatch(FetchBoundDevicesCommandAction());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/device/device_action.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_device_pairing_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_asset_with_badge.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../../utilities/ivory_color_mapper.dart';

class SettingsDevicePairingSuccessScreen extends StatelessWidget {
  static const routeName = "/settingsDevicePairingSuccessScreen";
  const SettingsDevicePairingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
            backButtonEnabled: false,
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          ),
          Expanded(
            child: Padding(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Device paired & Face\nID activated',
                    style: ClientConfig.getTextStyleScheme().heading1,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'You can now easily login and authorise payments.',
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: IvoryAssetWithBadge(
                      childWidget: SvgPicture(
                        SvgAssetLoader(
                          'assets/images/biometric_faceid.svg',
                          colorMapper: IvoryColorMapper(
                            baseColor: ClientConfig.getColorScheme().secondary,
                          ),
                        ),
                      ),
                      childPosition: BadgePosition.topEnd(top: -45, end: -25),
                      isSuccess: true,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Button(
                      text: 'Back to “Device pairing”',
                      disabledColor: const Color(0xFFDFE2E6),
                      color: ClientConfig.getColorScheme().tertiary,
                      textColor: ClientConfig.getColorScheme().surface,
                      onPressed: () {
                        
                        Navigator.popUntil(
                            context,
                            ModalRoute.withName(
                              SettingsDevicePairingScreen.routeName,
                            ));
                        StoreProvider.of<AppState>(context).dispatch(FetchBoundDevicesCommandAction());
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

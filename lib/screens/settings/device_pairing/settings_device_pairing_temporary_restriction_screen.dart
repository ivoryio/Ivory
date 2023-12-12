import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/device/device_action.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_device_pairing_screen.dart';
import 'package:solarisdemo/utilities/ivory_color_mapper.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class SettingsDevicePairingTemporaryRestrictionScreen extends StatelessWidget {
  static const routeName = "/settingsDevicePairingTemporaryRestrictionScreen";
  const SettingsDevicePairingTemporaryRestrictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        AppToolbar(
          padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
          onBackButtonPressed: () {
            Navigator.popUntil(context, ModalRoute.withName(SettingsDevicePairingScreen.routeName));
            StoreProvider.of<AppState>(context).dispatch(FetchBoundDevicesCommandAction());
          },
        ),
        Expanded(
          child: Padding(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Temporary pairing restriction",
                  style: ClientConfig.getTextStyleScheme().heading1,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16),
                Text(
                  "To ensure your account security, we've temporarily restricted device pairing after an incorrect attempt.",
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16),
                RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                    children: [
                      const TextSpan(
                        text: 'Please ',
                      ),
                      TextSpan(
                        text: 'come back in approximately 5 minutes ',
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                      ),
                      const TextSpan(
                        text: 'to try pairing your device again.',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SvgPicture(
                      SvgAssetLoader(
                        'assets/images/temporary_restriction.svg',
                        colorMapper: IvoryColorMapper(
                          baseColor: ClientConfig.getColorScheme().secondary,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: PrimaryButton(
                    text: 'Try again later',
                    onPressed: () {
                      Navigator.popUntil(context, ModalRoute.withName(SettingsDevicePairingScreen.routeName));
                      StoreProvider.of<AppState>(context).dispatch(FetchBoundDevicesCommandAction());
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/infrastructure/device/device_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/device/device_action.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_device_pairing_screen.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_device_pairing_verify_pairing_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../../config.dart';
import '../../../utilities/ivory_color_mapper.dart';

class SettingsDevicePairingInitialScreen extends StatelessWidget {
  static const routeName = "/settingsDevicePairingActivateFaceidScreen";
  const SettingsDevicePairingInitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = (StoreProvider.of<AppState>(context).state.authState as AuthenticatedState)
        .authenticatedUser
        .cognito;
    return ScreenScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            onBackButtonPressed: () {
              Navigator.popUntil(context, ModalRoute.withName(SettingsDevicePairingScreen.routeName));
              StoreProvider.of<AppState>(context).dispatch(FetchBoundDevicesCommandAction());
            },
          ),
          StoreConnector<AppState, DeviceBindingViewModel>(
            onDidChange: ((previousViewModel, viewModel) {
              if (previousViewModel is DeviceBindingLoadingViewModel && viewModel is DeviceBindingCreatedViewModel) {
                Navigator.pushNamed(context, SettingsDevicePairingVerifyPairingScreen.routeName);
              }
            }),
            converter: (store) => DeviceBindingPresenter.presentDeviceBinding(
              deviceBindingState: store.state.deviceBindingState,
            ),
            builder: (context, viewModel) {
              if (viewModel is DeviceBindingLoadingViewModel) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (viewModel is DeviceBindingErrorViewModel) {
                return const Center(
                  child: Text('Error'),
                );
              }
              return Expanded(
                child: Padding(
                  padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pair your device',
                        style: ClientConfig.getTextStyleScheme().heading1,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      RichText(
                        text: TextSpan(
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                          children: [
                            const TextSpan(text: 'Device pairing is necessary for '),
                            TextSpan(
                              text: 'actions like viewing card details and changing your PIN, ',
                              style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                            ),
                            const TextSpan(text: 'increasing app security with your safety in mind.'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Expanded(
                        child: Center(
                          child: SvgPicture(
                            SvgAssetLoader(
                              'assets/images/device_pairing.svg',
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
                        child: Button(
                          text: 'Not now',
                          disabledColor: ClientConfig.getCustomColors().neutral300,
                          color: ClientConfig.getColorScheme().surface,
                          textColor: ClientConfig.getColorScheme().tertiary,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: Button(
                          text: 'Pair device',
                          disabledColor: ClientConfig.getCustomColors().neutral300,
                          color: ClientConfig.getColorScheme().tertiary,
                          textColor: ClientConfig.getColorScheme().surface,
                          onPressed: () {
                            StoreProvider.of<AppState>(context).dispatch(CreateDeviceBindingCommandAction(user: user));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

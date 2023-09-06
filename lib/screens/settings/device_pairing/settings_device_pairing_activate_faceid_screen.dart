import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/infrastructure/device/device_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/device/device_action.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_device_pairing_verify_faceid_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../../config.dart';

class SettingsDevicePairingActivateFaceidScreen extends StatelessWidget {
  static const routeName = "/settingsDevicePairingActivateFaceidScreen";
  const SettingsDevicePairingActivateFaceidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user!.cognito;
    return ScreenScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
            padding: EdgeInsets.symmetric(
              horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              vertical: ClientConfig.getCustomClientUiSettings().defaultScreenVerticalPadding,
            ),
          ),

          StoreConnector<AppState, DeviceBindingViewModel>(
            onDidChange: ((previousViewModel, viewModel) {
              if (previousViewModel is DeviceBindingLoadingViewModel && viewModel is DeviceBindingCreatedViewModel) {
                Navigator.pushNamed(context, SettingsDevicePairingVerifyFaceidScreen.routeName);
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
                  padding: EdgeInsets.only(
                    left: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                    right: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                    bottom: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pair device by\nactivating Face ID',
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
                            const TextSpan(text: 'This will help you easily and seamlessly '),
                            TextSpan(
                                text: 'log in without a password, authorise payments ',
                                style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                            const TextSpan(text: 'and do multiple other operations.'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Expanded(
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/images/biometric_faceid.svg',
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: Button(
                          text: 'Not now',
                          disabledColor: const Color(0xFFDFE2E6),
                          color: ClientConfig.getColorScheme().surface,
                          textColor: ClientConfig.getColorScheme().tertiary,
                          onPressed: () {
                            StoreProvider.of<AppState>(context).dispatch(CreateDeviceBindingCommandAction(user: user));
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
                          text: 'Activate Face ID',
                          disabledColor: const Color(0xFFDFE2E6),
                          color: ClientConfig.getColorScheme().tertiary,
                          textColor: ClientConfig.getColorScheme().surface,
                          onPressed: () {},
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

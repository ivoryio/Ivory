import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/infrastructure/device/device_presenter.dart';
import 'package:solarisdemo/models/device.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/device/device_action.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_device_pairing_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_list_item_with_action.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../../config.dart';

class SettingsPairedDeviceDetailsScreenParams {
  final Device device;

  const SettingsPairedDeviceDetailsScreenParams({
    required this.device,
  });
}

class SettingsPairedDeviceDetailsScreen extends StatelessWidget {
  static const routeName = "/settingsPairedDeviceDetailsScreen";
  final SettingsPairedDeviceDetailsScreenParams params;

  const SettingsPairedDeviceDetailsScreen({
    super.key,
    required this.params,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user!.cognito;
    return ScreenScaffold(
      body: StoreConnector<AppState, DeviceBindingViewModel>(
        onDidChange: (previousViewModel, newViewModel) {
          if (previousViewModel is DeviceBindingLoadingViewModel && newViewModel is DeviceBindingDeletedViewModel) {
            Navigator.popUntil(context, ModalRoute.withName(SettingsDevicePairingScreen.routeName));
            StoreProvider.of<AppState>(context).dispatch(
              FetchBoundDevicesCommandAction(),
            );
          }
        },
        converter: (store) => DeviceBindingPresenter.presentDeviceBinding(
          deviceBindingState: store.state.deviceBindingState,
        ),
        builder: (context, viewModel) {
          if (viewModel is DeviceBindingLoadingViewModel) {
            return const Column(
              children: [
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ],
            );
          } else if (viewModel is DeviceBindingErrorViewModel) {
            return const Column(
              children: [
                Expanded(
                  child: Center(
                    child: Text('Error'),
                  ),
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppToolbar(
                backButtonEnabled: viewModel is! DeviceBindingLoadingViewModel,
                title: '',
                padding: EdgeInsets.symmetric(
                  horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                    right: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                    bottom: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                          color: Color(0xFFF8F9FA),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        params.device.deviceName,
                                        style: ClientConfig.getTextStyleScheme().heading2,
                                      ),
                                      Container(
                                        width: 48,
                                        height: 48,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: ClientConfig.getColorScheme().surface,
                                          borderRadius: BorderRadius.circular(1000),
                                        ),
                                        child: const Icon(
                                          Icons.phone_iphone,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'ID',
                                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                                        ),
                                        Text(
                                          params.device.deviceId.substring(0, 13),
                                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Brand',
                                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                                        ),
                                        Text(
                                          'IOS',
                                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Version',
                                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                                        ),
                                        Text(
                                          '15.4.1',
                                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Last login',
                                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '16:21, 13 Apr 2022',
                                              style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                                            ),
                                            Text(
                                              'near Berlin, Germany',
                                              style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        'Actions',
                        style: ClientConfig.getTextStyleScheme().labelLarge,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      IvoryListItemWithAction(
                        leftIcon: Icons.mobile_off,
                        leftIconColor: ClientConfig.getClientConfig().uiSettings.colorscheme.error,
                        actionName: 'Unpair device',
                        rightIcon: Icons.arrow_forward_ios,
                        rightIconColor: ClientConfig.getClientConfig().uiSettings.colorscheme.error,
                        actionSwitch: false,
                        onPressed: () {
                          showBottomModal(
                              context: context,
                              title:
                                  'Are you sure you want to unpair ${viewModel.thisDevice!.deviceName} (ID: ${viewModel.thisDevice!.deviceId.substring(0, 13)})?',
                              message:
                                  'You will not be able to make any transactions or other complex actions with this device.',
                              content: Column(
                                children: [
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  Button(
                                    text: 'No, go back',
                                    textColor: ClientConfig.getColorScheme().primary,
                                    border: Border.all(
                                      width: 2,
                                      color: ClientConfig.getColorScheme().primary,
                                      style: BorderStyle.solid,
                                    ),
                                    color: ClientConfig.getColorScheme().background,
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Button(
                                    text: 'Yes, unpair',
                                    color: const Color(0xFFE61F27),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      StoreProvider.of<AppState>(context).dispatch(
                                        DeleteBoundDeviceCommandAction(
                                          user: user,
                                          deviceId: params.device.deviceId,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

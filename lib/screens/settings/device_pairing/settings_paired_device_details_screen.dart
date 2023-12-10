import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/infrastructure/device/device_presenter.dart';
import 'package:solarisdemo/models/device.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/device/device_action.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_device_pairing_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/ivory_list_tile.dart';
import 'package:solarisdemo/widgets/ivory_list_title.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

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
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
              ),
              Expanded(
                child: ScrollableScreenContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(16),
                          ),
                          color: ClientConfig.getCustomColors().neutral100,
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      const IvoryListTitle(title: 'Actions'),
                      IvoryListTile(
                        leftIcon: Icons.mobile_off,
                        leftIconColor: ClientConfig.getClientConfig().uiSettings.colorscheme.error,
                        title: 'Unpair device',
                        rightIcon: Icons.arrow_forward_ios,
                        rightIconColor: ClientConfig.getClientConfig().uiSettings.colorscheme.error,
                        onTap: () {
                          _showUnpairModal(
                            context: context,
                          );
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

  void _showUnpairModal({
    required BuildContext context,
  }) {
    showBottomModal(
      context: context,
      title: 'Are you sure you want to unpair ${params.device.deviceName} '
          '(ID: ${params.device.deviceId})?',
      textWidget: Text(
        'You will not be able to make any transactions or other complex actions with this device.',
        style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
      ),
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
                  deviceId: params.device.deviceId,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

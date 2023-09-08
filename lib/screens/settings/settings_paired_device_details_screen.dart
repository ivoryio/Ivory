import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/infrastructure/device/device_presenter.dart';
import 'package:solarisdemo/models/device.dart';
import 'package:solarisdemo/redux/device/device_action.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/ivory_list_item_with_action.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';
import '../../redux/app_state.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
            title: '',
            padding: EdgeInsets.symmetric(
              horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            ),
          ),
          StoreConnector<AppState, DeviceBindingViewModel>(
            onDidChange: (previousViewModel, newViewModel) {
              if (previousViewModel is DeviceBindingLoadingViewModel && newViewModel is DeviceBindingDeletedViewModel) {
                Navigator.pop(context);
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
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (viewModel is DeviceBindingErrorViewModel) {
                return const Expanded(
                  child: Center(
                    child: Text('Error'),
                  ),
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
                                        style: const TextStyle(
                                          fontSize: 24,
                                          height: 24 / 32,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Container(
                                        width: 48,
                                        height: 48,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
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
                                        const Text(
                                          'ID',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            height: 24 / 16,
                                          ),
                                        ),
                                        Text(
                                          params.device.deviceId.substring(0, 13),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            height: 24 / 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Brand',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            height: 24 / 16,
                                          ),
                                        ),
                                        Text(
                                          'IOS',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            height: 24 / 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Version',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            height: 24 / 16,
                                          ),
                                        ),
                                        Text(
                                          '15.4.1',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            height: 24 / 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 4.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Last login',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            height: 24 / 16,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              '16:21, 13 Apr 2022',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                height: 24 / 16,
                                              ),
                                            ),
                                            Text(
                                              'near Berlin, Germany',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                height: 24 / 16,
                                              ),
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
                      const Text(
                        'Actions',
                        style: TextStyle(
                          fontSize: 18,
                          height: 24 / 18,
                          fontWeight: FontWeight.w600,
                        ),
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
                          StoreProvider.of<AppState>(context).dispatch(
                            DeleteBoundDeviceCommandAction(
                              user: user,
                              deviceId: params.device.deviceId,
                            ),
                          );
                        },
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

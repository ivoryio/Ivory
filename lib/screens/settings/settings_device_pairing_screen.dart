import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:solarisdemo/infrastructure/device/device_presenter.dart';
import 'package:solarisdemo/screens/wallet/card_details_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../models/user.dart';
import '../../redux/app_state.dart';
import '../../redux/device/device_action.dart';

class SettingsDevicePairingScreen extends StatelessWidget {
  static const routeName = "/settingsDevicePairingScreen";

  const SettingsDevicePairingScreen({super.key});

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
                  const Text(
                    'Device pairing',
                    style: TextStyle(
                      fontSize: 32,
                      height: 24 / 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  StoreConnector<AppState, DeviceBindingViewModel>(
                    onInit: (store) {
                      store.dispatch(FetchBoundDevicesCommandAction());
                    },
                    converter: (store) => DeviceBindingPresenter.presentDeviceBinding(
                      deviceBindingState: store.state.deviceBindingState,
                    ),
                    builder: (context, viewModel) {
                      if (viewModel is DeviceBindingLoadingViewModel) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (viewModel is DeviceBindingErrorViewModel) {
                        return const Center(
                          child: Text('Error'),
                        );
                      }
                      if (viewModel is DeviceBindingFetchedViewModel ||
                          viewModel is DeviceBindingFetchedButEmptyViewModel) {
                        return _buildPageContent(
                          context: context,
                          viewModel: viewModel,
                          user: user,
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              )),
        ),
      ],
    ));
  }

  Widget _buildPageContent({
    required BuildContext context,
    required DeviceBindingViewModel viewModel,
    required User user,
  }) {
    return Column(
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
                          viewModel.devices![0].deviceName,
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
                    Row(
                      children: [
                        Icon(
                          Icons.mobile_off,
                          size: 16,
                          color: viewModel is DeviceBindingFetchedViewModel ? Colors.green : Colors.red,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(viewModel is DeviceBindingFetchedViewModel ? 'Paired' : 'Not paired'),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: const Color(0xFFDFE2E6),
              ),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Paired devices limit',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${viewModel.devices!.length}/5',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: LinearPercentIndicator(
                          backgroundColor: const Color(0xFFE9EAEB),
                          progressColor: ClientConfig.getColorScheme().secondary,
                          lineHeight: 8,
                          barRadius: const Radius.circular(1000),
                          percent: viewModel.devices!.length / 5,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      Row(
                        children: [
                          Text('You can pair ${5 - viewModel.devices!.length} more devices'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (viewModel is DeviceBindingFetchedButEmptyViewModel)
                Container(
                  height: 1,
                  color: const Color(0xFFDFE2E6),
                ),
              
              if (viewModel is DeviceBindingFetchedButEmptyViewModel)
                GestureDetector(
                  onTap: () {
                    StoreProvider.of<AppState>(context).dispatch(CreateDeviceBindingCommandAction(user: user));
                  },
                  child: SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Pair device',
                        style: TextStyle(
                          color: ClientConfig.getColorScheme().secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (viewModel is DeviceBindingFetchedViewModel) _buildDeviceList(viewModel)
      ],
    );
  }

  Widget _buildDeviceList(DeviceBindingViewModel viewModel) {
    List<Widget> deviceWidgets = viewModel.devices!.map((device) {
      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          const SizedBox(
          height: 24,
        ),
          const Text(
          'Paired devices',
          style: TextStyle(
            fontSize: 18,
            height: 24 / 18,
            fontWeight: FontWeight.w600,
          ),
        ),
          const SizedBox(
          height: 24,
        ),
        IvoryActionItem(
          leftIcon: Icons.phonelink_ring,
            actionName: device.deviceName,
            actionDescription: 'ID: ${device.deviceId}',
          rightIcon: Icons.arrow_forward_ios,
          actionSwitch: false,
        ),
          const SizedBox(
          height: 32,
          ),
      ],
    );
    }).toList();

    return Column(
      children: deviceWidgets,
    );
}
}

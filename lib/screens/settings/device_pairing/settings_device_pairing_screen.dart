import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:solarisdemo/infrastructure/device/biometrics_service.dart';
import 'package:solarisdemo/infrastructure/device/device_presenter.dart';
import 'package:solarisdemo/ivory_app.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_action.dart';
import 'package:solarisdemo/redux/bank_card/bank_card_state.dart';
import 'package:solarisdemo/redux/device/device_action.dart';
import 'package:solarisdemo/screens/settings/app_settings/biometric_needed_screen.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_device_pairing_inital_screen.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_paired_device_details_screen.dart';
import 'package:solarisdemo/screens/wallet/card_details/card_details_screen.dart';
import 'package:solarisdemo/screens/wallet/change_pin/card_change_pin_choose_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/ivory_list_tile.dart';
import 'package:solarisdemo/widgets/ivory_list_title.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/screen_title.dart';
import 'package:solarisdemo/widgets/scrollable_screen_container.dart';

import '../../../config.dart';
import '../../../redux/app_state.dart';

class SettingsDevicePairingScreen extends StatelessWidget {
  static const routeName = "/settingsDevicePairingScreen";

  const SettingsDevicePairingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user =
        (StoreProvider.of<AppState>(context).state.authState as AuthenticatedAndConfirmedState).authenticatedUser;
    final scrollController = ScrollController();

    return ScreenScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
            title: "Device pairing",
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            scrollController: scrollController,
            onBackButtonPressed: () {
              _handleBackNavigation(user: user, context: context);
            },
          ),
          Expanded(
            child: ScrollableScreenContainer(
              scrollController: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScreenTitle(
                    "Device pairing",
                    padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
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
                      if (viewModel is DeviceBindingFetchedViewModel ||
                          viewModel is DeviceBindingFetchedButEmptyViewModel) {
                        return _buildPageContent(
                          context: context,
                          viewModel: viewModel,
                          user: user,
                        );
                      }
                      return const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent({
    required AuthenticatedUser user,
    required BuildContext context,
    required DeviceBindingViewModel viewModel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
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
                          viewModel.thisDevice!.deviceName,
                          style: ClientConfig.getTextStyleScheme().heading2,
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: ClientConfig.getColorScheme().background,
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
                color: ClientConfig.getCustomColors().neutral300,
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
                          Text(
                            'Paired devices limit',
                            style: ClientConfig.getTextStyleScheme().bodySmallBold,
                          ),
                          Text(
                            '${viewModel.devices != null ? viewModel.devices!.length : 0}/5',
                            style: ClientConfig.getTextStyleScheme().bodySmallBold,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: LinearPercentIndicator(
                          backgroundColor: ClientConfig.getCustomColors().neutral200,
                          progressColor: ClientConfig.getColorScheme().secondary,
                          lineHeight: 8,
                          barRadius: const Radius.circular(1000),
                          percent: (viewModel.devices != null ? viewModel.devices!.length : 0) / 5,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                              'You can pair ${5 - (viewModel.devices != null ? viewModel.devices!.length : 0)} more devices'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (viewModel is DeviceBindingFetchedButEmptyViewModel)
                Container(
                  height: 1,
                  color: ClientConfig.getCustomColors().neutral300,
                ),
              if (viewModel is DeviceBindingFetchedButEmptyViewModel)
                GestureDetector(
                  onTap: () async {
                    final isBiometricsAvailable = await BiometricsService.areBiometricsAvailable();
                    if (isBiometricsAvailable) {
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, SettingsDevicePairingInitialScreen.routeName);
                    } else {
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamed(context, AppSettingsBiometricNeededScreen.routeName);
                    }
                  },
                  child: SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        'Pair device',
                        style: ClientConfig.getTextStyleScheme().labelMedium.copyWith(
                              color: ClientConfig.getColorScheme().secondary,
                            ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (viewModel is DeviceBindingFetchedViewModel)
          const SizedBox(
            height: 24,
          ),
        if (viewModel is DeviceBindingFetchedViewModel)
          _buildDeviceList(
            context: context,
            viewModel: viewModel,
          ),
      ],
    );
  }

  Widget _buildDeviceList({
    required BuildContext context,
    required DeviceBindingViewModel viewModel,
  }) {
    List<Widget> deviceWidgets = viewModel.devices!.map((device) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IvoryListTitle(title: "Paired devices"),
          IvoryListTile(
            leftIcon: Icons.phonelink_ring,
            title: device.deviceName,
            subtitle: 'ID: ${device.deviceId.substring(0, 13)}',
            rightIcon: Icons.arrow_forward_ios,
            onTap: () {
              Navigator.pushNamed(
                context,
                SettingsPairedDeviceDetailsScreen.routeName,
                arguments: SettingsPairedDeviceDetailsScreenParams(device: device),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      );
    }).toList();

    return Column(
      children: deviceWidgets,
    );
  }

  void _handleBackNavigation({
    required BuildContext context,
    required AuthenticatedUser user,
  }) {
    if (IvoryApp.generalRouteObserver.isRouteInStackButNotCurrent(BankCardDetailsScreen.routeName)) {
      Navigator.popUntil(context, ModalRoute.withName(BankCardDetailsScreen.routeName));
      StoreProvider.of<AppState>(context).dispatch(
        BankCardFetchDetailsCommandAction(
          user: user,
          bankCard: (StoreProvider.of<AppState>(context).state.bankCardState as BankCardNoBoundedDevicesState).bankCard,
        ),
      );
    } else if (IvoryApp.generalRouteObserver.isRouteInStackButNotCurrent(BankCardChangePinChooseScreen.routeName)) {
      Navigator.popUntil(context, ModalRoute.withName(BankCardChangePinChooseScreen.routeName));
      StoreProvider.of<AppState>(context).dispatch(
        BankCardInitiatePinChangeCommandAction(
          user: user,
          bankCard: (StoreProvider.of<AppState>(context).state.bankCardState as BankCardNoBoundedDevicesState).bankCard,
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }
}

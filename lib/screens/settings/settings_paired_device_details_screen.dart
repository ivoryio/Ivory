import 'package:flutter/material.dart';
import 'package:solarisdemo/models/device.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/ivory_list_item_with_action.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text('Actions'),
                  IvoryListItemWithAction(
                    leftIcon: Icons.mobile_off,
                    leftIconColor: ClientConfig.getClientConfig().uiSettings.colorscheme.error,
                    actionName: 'actionName',
                    rightIcon: Icons.arrow_forward_ios,
                    rightIconColor: ClientConfig.getClientConfig().uiSettings.colorscheme.error,
                    actionSwitch: false,
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

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:solarisdemo/screens/wallet/card_details_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../config.dart';

class SettingsDevicePairingScreen extends StatelessWidget {
  static const routeName = "/settingsDevicePairingScreen";

  const SettingsDevicePairingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      color: Color(0xFFF8F9FA),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Iphone X',
                              style: TextStyle(
                                fontSize: 24,
                                height: 24 / 32,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              width: 48,
                              height: 48,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
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
                        const SizedBox(
                          height: 8,
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.mobile_off,
                              size: 16,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text('Not paired'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F9FA),
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFDFE2E6),
                        ),
                        top: BorderSide(
                          color: Color(0xFFDFE2E6),
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Paired devices limit',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '3/5',
                                style: TextStyle(
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
                              progressColor: const Color(0xFF2575FC),
                              lineHeight: 8,
                              barRadius: const Radius.circular(1000),
                              percent: 3 / 5,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                          const Row(
                            children: [
                              Text('You can pair ${5 - 3} more devices'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      print('Container clicked');
                    },
                    child: Container(
                      height: 48,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        color: Color(0xFFF8F9FA),
                      ),
                      child: const Center(
                        child: Text(
                          'Pair device',
                          style: TextStyle(
                            color: Color(0xFF2575FC),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
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
                  const IvoryActionItem(
                    leftIcon: Icons.phonelink_ring,
                    actionName: 'iPhone 13',
                    actionDescription: 'ID: 9476623',
                    rightIcon: Icons.arrow_forward_ios,
                    actionSwitch: false,
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  const IvoryActionItem(
                    leftIcon: Icons.lock_outline,
                    actionName: 'iPhone 11 Pro Max',
                    actionDescription: 'ID: 9476623',
                    rightIcon: Icons.arrow_forward_ios,
                    actionSwitch: false,
                  )
                ],
              )),
        ),
      ],
    ));
  }
}

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/infrastructure/device/biometrics_service.dart';
import 'package:solarisdemo/screens/settings/app_settings/biometric_enabled_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

import '../../../config.dart';
import '../../../utilities/ivory_color_mapper.dart';

class AppSettingsBiometricNeededScreen extends StatefulWidget {
  static const routeName = "/appSettingsBiometricNeededScreen";
  const AppSettingsBiometricNeededScreen({super.key});

  @override
  State<AppSettingsBiometricNeededScreen> createState() => _AppSettingsBiometricNeededScreenState();
}

class _AppSettingsBiometricNeededScreenState extends State<AppSettingsBiometricNeededScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      final bool isBiometricEnabled = await BiometricsService.areBiometricsAvailable();
      if (isBiometricEnabled) {
        // ignore: use_build_context_synchronously
        Navigator.popAndPushNamed(context, AppSettingsBiometricEnabledScreen.routeName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            onBackButtonPressed: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Padding(
              padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Biometrics needed',
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
                        TextSpan(
                          text: 'Enable biometrics ',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                        ),
                        const TextSpan(text: 'in your device\'s Security settings to '),
                        TextSpan(
                          text: 'log in without a password, authorise payments ',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                        ),
                        const TextSpan(text: 'and do multiple other operations.'),
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
                          'assets/images/enable_biometrics.svg',
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
                      text: 'Go to "Biometrics"',
                      disabledColor: const Color(0xFFDFE2E6),
                      color: ClientConfig.getColorScheme().tertiary,
                      textColor: ClientConfig.getColorScheme().surface,
                      onPressed: () {
                        AppSettings.openAppSettings(type: AppSettingsType.security);
                      },
                    ),
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

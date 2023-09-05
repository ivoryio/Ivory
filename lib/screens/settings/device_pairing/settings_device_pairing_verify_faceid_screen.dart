import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/tan_input.dart';

class SettingsDevicePairingVerifyFaceidScreen extends StatelessWidget {
  static const routeName = "/settingsDevicePairingVerifyFaceidScreen";
  const SettingsDevicePairingVerifyFaceidScreen({super.key});

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
                  Text(
                    'Verify Face ID activation',
                    style: ClientConfig.getTextStyleScheme().heading2,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: TextSpan(
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                      children: [
                        const TextSpan(text: 'Please enter below the '),
                        TextSpan(text: '6-digit code ', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                        const TextSpan(text: 'we sent to '),
                        TextSpan(
                            text: '+49 (30) 4587 8734.', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TanInput(
                    hintText: '#',
                    length: 6,
                    onCompleted: (String tan) {},
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Button(
                      text: 'Confirm',
                      disabledColor: const Color(0xFFDFE2E6),
                      color: ClientConfig.getColorScheme().tertiary,
                      textColor: ClientConfig.getColorScheme().surface,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/infrastructure/device/device_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/device/device_action.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_device_pairing_screen.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_device_pairing_success_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/tan_input.dart';

class SettingsDevicePairingVerifyFaceidScreen extends StatefulWidget {
  static const routeName = "/settingsDevicePairingVerifyFaceidScreen";
  const SettingsDevicePairingVerifyFaceidScreen({super.key});

  @override
  State<SettingsDevicePairingVerifyFaceidScreen> createState() => _SettingsDevicePairingVerifyFaceidScreenState();
}

class _SettingsDevicePairingVerifyFaceidScreenState extends State<SettingsDevicePairingVerifyFaceidScreen> {
  final TextEditingController _tanInputController = TextEditingController();
  bool _isInputComplete = false;

  void updateInputComplete(bool isComplete) {
    setState(() {
      _isInputComplete = isComplete;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.user!.cognito;
    return ScreenScaffold(
      body: StoreConnector<AppState, DeviceBindingViewModel>(
        onDidChange: (previousViewModel, viewModel) {
          if (previousViewModel is DeviceBindingLoadingViewModel &&
              viewModel is DeviceBindingChallengeVerifiedViewModel) {
            Navigator.pushNamed(context, SettingsDevicePairingSuccessScreen.routeName);
          }
        },
        converter: (store) => DeviceBindingPresenter.presentDeviceBinding(
          deviceBindingState: store.state.deviceBindingState,
        ),
        builder: (context, viewModel) {
          if (viewModel is DeviceBindingErrorViewModel) {
            return const Center(
              child: Text('Error'),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppToolbar(
                backButtonEnabled: viewModel is! DeviceBindingLoadingViewModel,
                padding: EdgeInsets.symmetric(
                  horizontal: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                  vertical: ClientConfig.getCustomClientUiSettings().defaultScreenVerticalPadding,
                ),
                onBackButtonPressed: () {
                  Navigator.popUntil(context, ModalRoute.withName(SettingsDevicePairingScreen.routeName));
                  StoreProvider.of<AppState>(context).dispatch(DeleteIncompleteDeviceBindingCommandAction());
                },
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
                            TextSpan(
                                text: '6-digit code ', style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                            const TextSpan(text: 'we sent to '),
                            TextSpan(
                                text: '+49 (30) 4587 8734.',
                                style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      TanInput(
                        hintText: '#',
                        length: 6,
                        onCompleted: (String tan) {
                          setState(() {
                            if (tan.length == 6) {
                              updateInputComplete(true);
                            }
                          });
                        },
                        controller: _tanInputController,
                        updateInputComplete: updateInputComplete,
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: Button(
                          text: 'Confirm',
                          disabledColor: const Color(0xFFDFE2E6),
                          color: ClientConfig.getColorScheme().tertiary,
                          textColor: ClientConfig.getColorScheme().surface,
                          isLoading: viewModel is DeviceBindingLoadingViewModel,
                          onPressed: _isInputComplete
                              ? () {
                                  StoreProvider.of<AppState>(context)
                                      .dispatch(VerifyDeviceBindingSignatureCommandAction(
                                    user: user,
                                    tan: '212212', //static tan
                                  ));
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

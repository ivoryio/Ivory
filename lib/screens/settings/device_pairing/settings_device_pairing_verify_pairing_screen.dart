import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/device/device_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/device/device_action.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_device_pairing_screen.dart';
import 'package:solarisdemo/screens/settings/device_pairing/settings_device_pairing_success_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/tan_input.dart';

class SettingsDevicePairingVerifyPairingScreen extends StatefulWidget {
  static const routeName = "/settingsDevicePairingVerifyFaceidScreen";
  const SettingsDevicePairingVerifyPairingScreen({super.key});

  @override
  State<SettingsDevicePairingVerifyPairingScreen> createState() => _SettingsDevicePairingVerifyPairingScreenState();
}

class _SettingsDevicePairingVerifyPairingScreenState extends State<SettingsDevicePairingVerifyPairingScreen> {
  final TextEditingController _tanInputController = TextEditingController();
  bool _isInputComplete = false;

  void updateInputComplete(bool isComplete) {
    setState(() {
      _isInputComplete = isComplete;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenScaffold(
      body: StoreConnector<AppState, DeviceBindingViewModel>(
        onDidChange: (previousViewModel, viewModel) {
          if (previousViewModel is DeviceBindingLoadingViewModel &&
              viewModel is DeviceBindingChallengeVerifiedViewModel) {
            Navigator.pushNamed(context, SettingsDevicePairingSuccessScreen.routeName);
          }
          if (previousViewModel is DeviceBindingLoadingViewModel &&
              viewModel is DeviceBindingVerificationErrorViewModel) {
            showBottomModal(
              context: context,
              isDismissible: false,
              showCloseButton: true,
              title: "Code was incorrect",
              textWidget: RichText(
                text: TextSpan(
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  children: [
                    const TextSpan(
                      text:
                          'To ensure your account security, we\'ve temporarily restricted device pairing after an incorrect attempt. \n\n',
                    ),
                    const TextSpan(
                      text: 'Please ',
                    ),
                    TextSpan(
                      text: 'try again in approximately 5 minutes.',
                      style: ClientConfig.getTextStyleScheme().bodyLargeRegularBold,
                    ),
                  ],
                ),
              ),
              content: Column(
                children: [
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: 'Try again later',
                      onPressed: () async {
                        StoreProvider.of<AppState>(context).dispatch(DeleteIncompleteDeviceBindingCommandAction());
                        Navigator.popUntil(context, ModalRoute.withName(SettingsDevicePairingScreen.routeName));
                      },
                    ),
                  ),
                ],
              ),
            );
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
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                onBackButtonPressed: () {
                  showBottomModal(
                    context: context,
                    isDismissible: false,
                    showCloseButton: true,
                    title: 'Are you sure you want to leave device pairing?',
                    textWidget:
                        const Text('You will need to wait for 5 minutes to pair your device again if you leave now.'),
                    content: Column(
                      children: [
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: SecondaryButton(
                            text: 'Cancel',
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: Button(
                            color: ClientConfig.getColorScheme().error,
                            text: 'Yes, leave',
                            onPressed: () async {
                              Navigator.popUntil(context, ModalRoute.withName(SettingsDevicePairingScreen.routeName));
                              StoreProvider.of<AppState>(context).dispatch(
                                DeleteIncompleteDeviceBindingCommandAction(),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Verify device pairing',
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
                          disabledColor: ClientConfig.getCustomColors().neutral300,
                          color: ClientConfig.getColorScheme().tertiary,
                          textColor: ClientConfig.getColorScheme().surface,
                          isLoading: viewModel is DeviceBindingLoadingViewModel,
                          onPressed: _isInputComplete
                              ? () {
                                  StoreProvider.of<AppState>(context).dispatch(
                                    VerifyDeviceBindingSignatureCommandAction(
                                      tan: _tanInputController.text,
                                    ),
                                  );
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

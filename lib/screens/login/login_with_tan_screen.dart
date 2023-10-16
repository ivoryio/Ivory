import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/auth/auth_presenter.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_action.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/button.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/tan_input.dart';

class LoginWithTanScreen extends StatefulWidget {
  static const routeName = "/loginTanScreen";
  final AuthViewModel viewModel;

  const LoginWithTanScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<LoginWithTanScreen> createState() => _LoginWithTanScreenState();
}

class _LoginWithTanScreenState extends State<LoginWithTanScreen> {
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppToolbar(
            backButtonEnabled: widget.viewModel is! AuthLoadingViewModel,
            actions: [
              SvgPicture.asset(
                'assets/images/ivory-logo-small.svg',
              ),
            ],
            padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
            onBackButtonPressed: () {
              StoreProvider.of<AppState>(context).dispatch(
                LoadCredentialsCommandAction(),
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
                    "Verify login",
                    style: ClientConfig.getTextStyleScheme().heading1,
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
                  const SizedBox(height: 24),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Button(
                      text: 'Confirm',
                      disabledColor: const Color(0xFFDFE2E6),
                      color: ClientConfig.getColorScheme().tertiary,
                      textColor: ClientConfig.getColorScheme().surface,
                      isLoading: widget.viewModel is AuthLoadingViewModel,
                      onPressed: _isInputComplete
                          ? () {
                              StoreProvider.of<AppState>(context).dispatch(
                                ConfirmTanAuthenticationCommandAction(
                                  cognitoUser: (StoreProvider.of<AppState>(context).state.authState
                                          as AuthenticatedWithoutBoundDeviceState)
                                      .cognitoUser,
                                  tan: _tanInputController.text,
                                  onSuccess: () {
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
                                  },
                                ),
                              );
                            }
                          : null,
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

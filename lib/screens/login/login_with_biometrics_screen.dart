import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/auth/auth_presenter.dart';
import 'package:solarisdemo/navigator.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_action.dart';
import 'package:solarisdemo/redux/auth/auth_state.dart';
import 'package:solarisdemo/screens/home/home_screen.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';

class LoginWithBiometricsScreen extends StatefulWidget {
  static const routeName = "/loginTanScreen";
  final AuthViewModel viewModel;

  const LoginWithBiometricsScreen({
    super.key,
    required this.viewModel,
  });

  @override
  State<LoginWithBiometricsScreen> createState() => _LoginWithBiometricsScreenState();
}

class _LoginWithBiometricsScreenState extends State<LoginWithBiometricsScreen> {
  String firstName = '';
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AuthViewModel>(
      onInit: (store) {
        if (store.state.authState is AuthenticatedWithBoundDeviceState) {
          final cognitoUser =
              (StoreProvider.of<AppState>(context).state.authState as AuthenticatedWithBoundDeviceState).cognitoUser;
          firstName = cognitoUser.firstName!;
          store.dispatch(
            ConfirmBiometricAuthenticationCommandAction(
              cognitoUser: cognitoUser,
              onSuccess: () {
                Navigator.of(
                  navigatorKey.currentContext as BuildContext,
                ).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
              },
            ),
          );
        }
      },
      builder: (context, viewModel) {
        return ScreenScaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppToolbar(
                actions: [
                  SvgPicture.asset(
                    'assets/images/ivory-logo-small.svg',
                  ),
                ],
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                backButtonEnabled: false,
              ),
              Expanded(
                child: Padding(
                  padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Great to see you back, $firstName",
                        style: ClientConfig.getTextStyleScheme().heading1,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text('Unlock your account with biometrics.',
                          style: ClientConfig.getTextStyleScheme().bodyLargeRegular),
                      const SizedBox(
                        height: 24,
                      ),
                      const Spacer(),
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      converter: (store) => AuthPresenter.presentAuth(authState: store.state.authState),
    );
  }
}

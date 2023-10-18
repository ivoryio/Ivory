// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/auth/auth_presenter.dart';
import 'package:solarisdemo/models/auth/auth_error_type.dart';
import 'package:solarisdemo/navigator.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_action.dart';
import 'package:solarisdemo/screens/login/login_with_tan_screen.dart';
import 'package:solarisdemo/screens/login/modals/mobile_number_country_picker_popup.dart';
import 'package:solarisdemo/services/device_service.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/checkbox.dart';
import 'package:solarisdemo/widgets/continue_button_controller.dart';
import 'package:solarisdemo/widgets/modal.dart';
import 'package:solarisdemo/widgets/screen_scaffold.dart';
import 'package:solarisdemo/widgets/screen_title.dart';

import '../../cubits/login_cubit/login_cubit.dart';
import '../../utilities/validator.dart';
import '../../widgets/button.dart';
import '../../widgets/tab_view.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/loginScreen";

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    return StoreConnector<AppState, AuthViewModel>(
      onInit: (store) {
        store.dispatch(
          LoadCredentialsCommandAction(),
        );
      },
      onWillChange: (previousViewModel, newViewModel) {
        if (previousViewModel is AuthLoadingViewModel && newViewModel is AuthenticatedWithoutBoundDeviceViewModel) {
          Navigator.of(
            navigatorKey.currentContext as BuildContext,
          ).pushNamed(LoginWithTanScreen.routeName);
        }
      },
      converter: (store) => AuthPresenter.presentAuth(authState: store.state.authState),
      builder: (context, viewModel) {
        return ScreenScaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppToolbar(
                title: "Login",
                backButtonEnabled: viewModel is! AuthLoadingViewModel,
                scrollController: scrollController,
                padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                actions: const [
                  AppbarLogo(),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: ClientConfig.getCustomClientUiSettings().defaultScreenPadding,
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ScreenTitle(
                          "Login",
                        ),
                        const SizedBox(height: 24),
                        TabView(
                          tabs: [
                            TabViewItem(
                              text: "Email",
                              child: EmailLoginForm(
                                viewModel: viewModel,
                              ),
                            ),
                            const TabViewItem(
                              text: "Phone number",
                              child: PhoneNumberLoginForm(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}

class PhoneNumberLoginForm extends StatefulWidget {
  const PhoneNumberLoginForm({super.key});

  @override
  State<PhoneNumberLoginForm> createState() => _PhoneNumberLoginFormState();
}

class _PhoneNumberLoginFormState extends State<PhoneNumberLoginForm> {
  bool isLoginEnabled = false;
  bool hidePassword = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController(text: '+49');
  TextEditingController passwordInputController = TextEditingController();

  void onChanged() {
    bool isInputValid = phoneController.text.isNotEmpty && passwordInputController.text.isNotEmpty;

    if (isInputValid && !isLoginEnabled) {
      setState(() {
        isLoginEnabled = true;
      });
    }

    if (!isInputValid && isLoginEnabled) {
      setState(() {
        isLoginEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mobile number',
                  style: ClientConfig.getTextStyleScheme().labelSmall,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 48,
                      padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: ClientConfig.getCustomColors().neutral500,
                          style: BorderStyle.solid,
                        ),
                        borderRadius:
                            const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                        color: ClientConfig.getCustomColors().neutral100,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          showBottomModal(
                            context: context,
                            title: "Select mobile number prefix",
                            content: CountryPickerPopup(
                              onChangedSearch: (value) {},
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Image.asset('assets/images/germany_flag.png'),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.expand_more,
                              color: ClientConfig.getCustomColors().neutral500,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                        autofocus: true,
                        controller: phoneController,
                        onChanged: (inputValue) {
                          if (inputValue.isEmpty) inputValue = '0';

                          setState(() {});
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          filled: true,
                          fillColor: ClientConfig.getCustomColors().neutral100,
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              width: 1,
                              color: ClientConfig.getCustomColors().neutral500,
                              style: BorderStyle.solid,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                              width: 1,
                              color: ClientConfig.getColorScheme().primary,
                              style: BorderStyle.solid,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  'Password',
                  style: ClientConfig.getTextStyleScheme().labelSmall,
                ),
                const SizedBox(height: 8),
                TextField(
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  autofocus: true,
                  obscureText: hidePassword,
                  controller: passwordInputController,
                  onChanged: (inputValue) {},
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    filled: true,
                    fillColor: ClientConfig.getCustomColors().neutral100,
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                        width: 1,
                        color: ClientConfig.getCustomColors().neutral400,
                        style: BorderStyle.solid,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                        width: 1,
                        color: ClientConfig.getColorScheme().primary,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    CheckboxWidget(
                      isChecked: false,
                      onChanged: (bool? value) {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text('Show password'),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 210,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Forgot your email address?",
                  style: ClientConfig.getTextStyleScheme().labelMedium.copyWith(
                        color: ClientConfig.getColorScheme().secondary,
                      ),
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  child: PrimaryButton(
                    text: "Continue",
                    onPressed: isLoginEnabled
                        ? () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              String phoneNumber = phoneController.text;
                              String password = passwordInputController.text;
                              String? deviceConsentId = await OldDeviceService.getDeviceConsentId();
                              if (deviceConsentId.isNotEmpty) {
                                context.read<LoginCubit>().setCredentials(
                                      phoneNumber: phoneNumber,
                                      password: password,
                                    );
                              } else {
                                context.read<LoginCubit>().requestConsent(
                                      phoneNumber: phoneNumber,
                                      password: password,
                                    );
                              }
                            }
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EmailLoginForm extends StatefulWidget {
  final AuthViewModel viewModel;
  const EmailLoginForm({
    super.key,
    required this.viewModel,
  });

  @override
  State<EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _hasValidationError = false;
  bool _hidePassword = true;
  bool isCompleted = false;
  late TextEditingController _emailInputController;
  late TextEditingController _passwordInputController;
  late ContinueButtonController continueButtonController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailInputController = TextEditingController();
    _passwordInputController = TextEditingController();
    continueButtonController = ContinueButtonController();

    _emailInputController.addListener(onChangeEmailAddress);
    _passwordInputController.addListener(onChangePassword);
  }

  void onChangeEmailAddress() {
    bool isInputValid =
        _emailInputController.text.isNotEmpty && Validator.isValidEmailAddress(_emailInputController.text);

    setState(() {
      _hasValidationError = !isInputValid;
    });

    if (isInputValid && !_isEmailValid) {
      setState(() {
        _isEmailValid = true;
        _hasValidationError = false;
      });
    }

    if (!isInputValid && _isEmailValid) {
      setState(() {
        _isEmailValid = false;
        _hasValidationError = true;
      });
    }
  }

  void onChangePassword() {
    bool isInputValid = _passwordInputController.text.isNotEmpty && _passwordInputController.text.length >= 6;

    if (isInputValid && !_isPasswordValid) {
      setState(() {
        _isPasswordValid = true;
      });
    }

    if (!isInputValid && _isPasswordValid) {
      setState(() {
        _isPasswordValid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.viewModel is AuthInitialViewModel &&
        widget.viewModel.email != null &&
        widget.viewModel.password != null &&
        _emailInputController.text.isEmpty &&
        _passwordInputController.text.isEmpty) {
      _emailInputController.text = widget.viewModel.email!;
      _passwordInputController.text = widget.viewModel.password!;

      setState(() {
        _isEmailValid = true;
        _isPasswordValid = true;
      });
    }

    if (widget.viewModel is AuthErrorViewModel && isCompleted == true) {
      setState(() {
        _isEmailValid = false;
        _isPasswordValid = false;
        isCompleted = false;
      });
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.viewModel is AuthErrorViewModel && (!_isEmailValid || !_isPasswordValid))
                  AuthErrorContainer(
                    errorType: widget.viewModel.errorType!,
                  ),
                if (widget.viewModel is AuthErrorViewModel && (!_isEmailValid || !_isPasswordValid))
                  const SizedBox(
                    height: 24,
                  ),
                Text(
                  'Email address',
                  style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(
                        color: _hasValidationError || !_isEmailValid
                            ? const Color(0xFFE61F27)
                            : ClientConfig.getCustomColors().neutral700,
                      ),
                ),
                const SizedBox(height: 8),
                TextField(
                  onTap: () {
                    if (widget.viewModel is AuthErrorViewModel) {
                      setState(() {
                        _isEmailValid = true;
                      });
                    }
                  },
                  enabled: !isCompleted,
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  controller: _emailInputController,
                  onChanged: (inputValue) => onChangeEmailAddress(),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    filled: true,
                    fillColor: _hasValidationError || !_isEmailValid
                        ? const Color(0xFFFFE9EA)
                        : ClientConfig.getCustomColors().neutral100,
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                        width: 1,
                        color: _hasValidationError || !_isEmailValid
                            ? const Color(0xFFE61F27)
                            : ClientConfig.getCustomColors().neutral500,
                        style: BorderStyle.solid,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                        width: 1,
                        color: _hasValidationError || !_isEmailValid
                            ? const Color(0xFFE61F27)
                            : ClientConfig.getColorScheme().primary,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
                if (_hasValidationError) const SizedBox(height: 8),
                if (_hasValidationError)
                  Text(
                    'Please input a valid email address: example@gmail.com',
                    style: ClientConfig.getTextStyleScheme().bodySmallRegular.copyWith(
                          color: const Color(0xFFE61F27),
                        ),
                  ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  'Password',
                  style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(
                        color: !_isPasswordValid ? const Color(0xFFE61F27) : ClientConfig.getCustomColors().neutral700,
                      ),
                ),
                const SizedBox(height: 8),
                TextField(
                  onTap: () {
                    if (widget.viewModel is AuthErrorViewModel) {
                      setState(() {
                        _isPasswordValid = true;
                      });
                    }
                  },
                  enabled: !isCompleted,
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  obscureText: _hidePassword,
                  controller: _passwordInputController,
                  onChanged: (inputValue) => onChangePassword(),
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    filled: true,
                    fillColor: !_isPasswordValid ? const Color(0xFFFFE9EA) : ClientConfig.getCustomColors().neutral100,
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                        width: 1,
                        color: !_isPasswordValid ? const Color(0xFFE61F27) : ClientConfig.getCustomColors().neutral500,
                        style: BorderStyle.solid,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                        width: 1,
                        color: !_isPasswordValid ? const Color(0xFFE61F27) : ClientConfig.getColorScheme().primary,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    CheckboxWidget(
                      isChecked: false,
                      onChanged: (bool? value) {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text('Show password'),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: widget.viewModel is AuthErrorViewModel && (!_isEmailValid || !_isPasswordValid) ? 100 : 210,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Forgot your email address?",
                  style: ClientConfig.getTextStyleScheme().labelMedium.copyWith(
                        color: widget.viewModel is AuthLoadingViewModel
                            ? ClientConfig.getCustomColors().neutral500
                            : ClientConfig.getColorScheme().secondary,
                      ),
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: Button(
                    text: 'Continue',
                    disabledColor: ClientConfig.getCustomColors().neutral300,
                    color: ClientConfig.getColorScheme().tertiary,
                    textColor: ClientConfig.getColorScheme().surface,
                    isLoading: widget.viewModel is AuthLoadingViewModel,
                    onPressed: _isEmailValid && _isPasswordValid
                        ? () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              String emailAddress = _emailInputController.text;
                              String password = _passwordInputController.text;
                              setState(() {
                                isCompleted = true;
                              });
                              StoreProvider.of<AppState>(context).dispatch(
                                AuthenticateUserCommandAction(
                                  email: emailAddress,
                                  password: password,
                                ),
                              );
                            }
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AuthErrorContainer extends StatelessWidget {
  final AuthErrorType errorType;

  const AuthErrorContainer({
    Key? key,
    required this.errorType,
  }) : super(key: key);

  String getErrorTitle() {
    switch (errorType) {
      case AuthErrorType.invalidCredentials:
        return 'Wrong email or password';
      case AuthErrorType.cantCreateConsent:
        return 'Consent Creation Failed';
      case AuthErrorType.cantCreateFingerprint:
        return 'Fingerprint Creation Failed';
      case AuthErrorType.biometricAuthFailed:
        return 'Biometric Authentication Failed';
      case AuthErrorType.cantGetPersonData:
        return 'Unable to Retrieve Person Data';
      case AuthErrorType.cantGetPersonAccountData:
        return 'Unable to Retrieve Account Data';
      default:
        return 'Unknown Error';
    }
  }

  String getErrorDescription() {
    switch (errorType) {
      case AuthErrorType.invalidCredentials:
        return 'Please double-check the information you\'ve entered and try with a different email or password.';
      case AuthErrorType.cantCreateConsent:
      case AuthErrorType.cantCreateFingerprint:
      case AuthErrorType.biometricAuthFailed:
        return 'An error occurred while processing your request. Please try again.';
      case AuthErrorType.cantGetPersonData:
      case AuthErrorType.cantGetPersonAccountData:
        return 'There was a problem retrieving your data. Please check your network connection and try again.';
      default:
        return 'An unknown error occurred. Please try again or contact support.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0XFFFFE9EA),
        border: Border.all(
          width: 1,
          color: const Color(0xFFFFBDBF),
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getErrorTitle(),
            style: ClientConfig.getTextStyleScheme().bodySmallBold,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            getErrorDescription(),
            style: ClientConfig.getTextStyleScheme().bodySmallRegular,
          ),
        ],
      ),
    );
  }
}

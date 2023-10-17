// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/infrastructure/auth/auth_presenter.dart';
import 'package:solarisdemo/models/auth/auth_loading_type.dart';
import 'package:solarisdemo/redux/app_state.dart';
import 'package:solarisdemo/redux/auth/auth_action.dart';
import 'package:solarisdemo/screens/login/login_with_biometrics_screen.dart';
import 'package:solarisdemo/screens/login/login_with_tan_screen.dart';
import 'package:solarisdemo/services/device_service.dart';
import 'package:solarisdemo/widgets/app_toolbar.dart';
import 'package:solarisdemo/widgets/checkbox.dart';
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
      converter: (store) => AuthPresenter.presentAuth(authState: store.state.authState),
      builder: (context, viewModel) {
        if (viewModel is AuthErrorViewModel) {}
        if (viewModel is AuthenticatedWithoutBoundDeviceViewModel ||
            viewModel.loadingType == AuthLoadingType.confirmWithTan) {
          return LoginWithTanScreen(
            viewModel: viewModel,
          );
        }
        if (viewModel is AuthenticatedWithBoundDeviceViewModel ||
            viewModel.loadingType == AuthLoadingType.confirmWithBiometrics) {
          return LoginWithBiometricsScreen(
            viewModel: viewModel,
          );
        }
        if (viewModel is AuthInitialViewModel ||
            viewModel.loadingType == AuthLoadingType.initAuth ||
            viewModel.loadingType == AuthLoadingType.authenticate) {
          return ScreenScaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppToolbar(
                  title: "Login",
                  backButtonEnabled: viewModel is! AuthLoadingViewModel,
                  scrollController: scrollController,
                  padding: ClientConfig.getCustomClientUiSettings().defaultScreenHorizontalPadding,
                  actions: [
                    SvgPicture.asset(
                      'assets/images/ivory-logo-small.svg',
                    ),
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
        }
        return const GenericLoadingScreen();
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
                  // width: double.infinity,
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
  bool isEmailValid = false;
  bool isPasswordValid = false;
  bool hasError = false;
  bool hidePassword = true;
  bool isCompleted = false;
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onChangeEmailAddress() {
    bool isInputValid =
        emailInputController.text.isNotEmpty && Validator.isValidEmailAddress(emailInputController.text);

    setState(() {
      hasError = !isInputValid;
    });

    if (isInputValid && !isEmailValid) {
      setState(() {
        isEmailValid = true;
        hasError = false;
      });
    }

    if (!isInputValid && isEmailValid) {
      setState(() {
        isEmailValid = false;
        hasError = true;
      });
    }
  }

  void onChangePassword() {
    bool isInputValid = passwordInputController.text.isNotEmpty && passwordInputController.text.length >= 6;

    if (isInputValid && !isPasswordValid) {
      setState(() {
        isPasswordValid = true;
      });
    }

    if (!isInputValid && isPasswordValid) {
      setState(() {
        isPasswordValid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    if (widget.viewModel is AuthInitialViewModel &&
        widget.viewModel.email != null &&
        widget.viewModel.password != null &&
        emailInputController.text.isEmpty &&
        passwordInputController.text.isEmpty) {
      emailInputController.text = widget.viewModel.email!;
      passwordInputController.text = widget.viewModel.password!;

      // FocusScope.of(context).unfocus();

      setState(() {
        isEmailValid = true;
        isPasswordValid = true;
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
                Text(
                  'Email address',
                  style: ClientConfig.getTextStyleScheme().labelSmall.copyWith(
                        color: hasError ? const Color(0xFFE61F27) : ClientConfig.getCustomColors().neutral700,
                      ),
                ),
                const SizedBox(height: 8),
                TextField(
                  enabled: !isCompleted,
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  // autofocus: true,
                  controller: emailInputController,
                  onChanged: (inputValue) => onChangeEmailAddress(),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    filled: true,
                    fillColor: hasError ? const Color(0xFFFFE9EA) : ClientConfig.getCustomColors().neutral100,
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                        width: 1,
                        color: hasError ? const Color(0xFFE61F27) : ClientConfig.getCustomColors().neutral500,
                        style: BorderStyle.solid,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      borderSide: BorderSide(
                        width: 1,
                        color: hasError ? const Color(0xFFE61F27) : ClientConfig.getColorScheme().primary,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
                if (hasError) const SizedBox(height: 8),
                if (hasError)
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
                  style: ClientConfig.getTextStyleScheme().labelSmall,
                ),
                const SizedBox(height: 8),
                TextField(
                  enabled: !isCompleted,
                  style: ClientConfig.getTextStyleScheme().bodyLargeRegular,
                  obscureText: hidePassword,
                  controller: passwordInputController,
                  onChanged: (inputValue) => onChangePassword(),
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
                        color: ClientConfig.getCustomColors().neutral500,
                        // color: isErrorRange ? Colors.red : const Color(0xFFADADB4),
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
                        // color: isErrorRange ? Colors.red : const Color(0xFFADADB4),
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
                    onPressed: isEmailValid && isPasswordValid
                        ? () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              String emailAddress = emailInputController.text;
                              String password = passwordInputController.text;
                              setState(() {
                                isCompleted = true;
                              });
                              StoreProvider.of<AppState>(context).dispatch(
                                AuthenticateUserCommandAction(
                                  email: emailAddress,
                                  phoneNumber: '',
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

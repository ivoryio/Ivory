// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solarisdemo/screens/login/login_consent_screen.dart';

import '../../services/device_service.dart';
import '../../utilities/validator.dart';
import '../../widgets/sticky_bottom_content.dart';
import '../../widgets/tab_view.dart';
import 'login_tan_screen.dart';
import '../../widgets/auth_error.dart';
import '../../widgets/button.dart';
import '../../widgets/screen.dart';
import '../../services/auth_service.dart';
import '../../widgets/platform_text_input.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/login_cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = context.read<AuthCubit>();
    final AuthService authService = AuthService();

    return BlocProvider(
      create: (context) => LoginCubit(
        authCubit: authCubit,
        authService: authService,
      ),
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          if (state is LoginInitial) {
            return const Screen(
              title: "Login",
              hideBottomNavbar: true,
              child: LoginOptions(),
            );
          }

          if (state is LoginLoading) {
            return const LoadingScreen(title: "Login");
          }

          if (state is LoginError) {
            return AuthErrorScreen(message: state.message, title: "Login");
          }
          if (state is LoginRequestConsent) {
            return GdprConsentScreen(
              bottomStickyWidget: BottomStickyWidget(
                child: StickyBottomContent(
                  buttonText: "I agree",
                  onContinueCallback: () {
                    context.read<LoginCubit>().setCredentials(
                          email: state.email,
                          phoneNumber: state.phoneNumber,
                          password: state.password!,
                        );
                  },
                ),
              ),
            );
          }

          if (state is LoginUserExists) {
            return const LoginTanScreen();
          }

          return const ErrorScreen();
        },
      ),
    );
  }
}

class LoginOptions extends StatelessWidget {
  const LoginOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(30, 10, 30, 50),
      child: TabView(
        tabs: [
          TabViewItem(text: "Phone number", child: PhoneNumberLoginForm()),
          TabViewItem(text: "Email", child: EmailLoginForm()),
        ],
      ),
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();

  void onChanged() {
    bool isInputValid = phoneController.text.isNotEmpty &&
        passwordInputController.text.isNotEmpty;

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
    return Expanded(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  PlatformTextInput(
                    controller: phoneController,
                    textLabel: "Phone number",
                    hintText: "e.g 555 555 555",
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }

                      return null;
                    },
                    onChanged: (value) => onChanged(),
                  ),
                  PlatformTextInput(
                    controller: passwordInputController,
                    textLabel: "Password",
                    hintText: "",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onChanged: (value) => onChanged(),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Forgot your phone number?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: "Continue",
                      onPressed: isLoginEnabled
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                String phoneNumber = phoneController.text;
                                String password = passwordInputController.text;
                                String? deviceConsentId =
                                    await DeviceUtilService
                                        .getDeviceConsentId();
                                if (deviceConsentId != null &&
                                    deviceConsentId.isNotEmpty) {
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
      ),
    );
  }
}

class EmailLoginForm extends StatefulWidget {
  const EmailLoginForm({super.key});

  @override
  State<EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  bool isLoginEnabled = false;
  TextEditingController emailInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void onChange() {
    bool isInputValid = emailInputController.text.isNotEmpty &&
        passwordInputController.text.isNotEmpty;

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

  Future<CacheCredentials?> getCredentials() async {
    CacheCredentials? credentials =
        await DeviceUtilService.getCredentialsFromCache();

    if (credentials != null) {
      emailInputController.text = credentials.email ?? "";
      passwordInputController.text = credentials.password ?? "";
      setState(() {
        isLoginEnabled = true;
      });
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    getCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: [
                  PlatformTextInput(
                    controller: emailInputController,
                    textLabel: "Email Address",
                    hintText: "e.g john.doe@gmail.com",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email address';
                      }
                      if (!Validator.isValidEmailAddress(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onChanged: (value) => onChange(),
                  ),
                  PlatformTextInput(
                    controller: passwordInputController,
                    textLabel: "Password",
                    hintText: "",
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }

                      return null;
                    },
                    onChanged: (value) => onChange(),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "Forgot your email address?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: "Continue",
                      onPressed: isLoginEnabled
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                String emailAddress = emailInputController.text;
                                String password = passwordInputController.text;
                                String? deviceConsentId =
                                    await DeviceUtilService
                                        .getDeviceConsentId();
                                if (deviceConsentId != null &&
                                    deviceConsentId.isNotEmpty) {
                                  context.read<LoginCubit>().setCredentials(
                                        email: emailAddress,
                                        password: password,
                                      );
                                } else {
                                  context.read<LoginCubit>().requestConsent(
                                        email: emailAddress,
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
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_tan_screen.dart';
import 'login_passcode_error.dart';
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
    final AuthService authService = AuthService(context: context);

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
              return LoginPasscodeErrorScreen(message: state.message);
            }

            if (state is LoginUserExists) {
              return const LoginTanScreen();
            }

            return const ErrorScreen();
          },
        ));
  }
}

class LoginOptions extends StatefulWidget {
  const LoginOptions({super.key});

  @override
  State<LoginOptions> createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page = _selectedIndex == 0
        ? const PhoneNumberLoginForm()
        : const EmailLoginForm();

    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 50),
      child: Column(
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: const Color(0xfff5f5f5),
                borderRadius: const BorderRadius.all(Radius.circular(9.0)),
                border: Border.all(width: 1, color: const Color(0xffB9B9B9))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TabExpandedButton(
                  active: _selectedIndex == 0,
                  text: "Phone number",
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                TabExpandedButton(
                  active: _selectedIndex == 1,
                  text: "Email",
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: page,
          ),
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneController = TextEditingController();
    TextEditingController passwordInputController = TextEditingController();

    return Form(
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
                  child: SecondaryButton(
                    text: "Continue",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        String phoneNumber = phoneController.text;
                        String password = passwordInputController.text;

                        context.read<LoginCubit>().setCredentials(
                              phoneNumber: phoneNumber,
                              password: password,
                            );
                      }
                    },
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
  const EmailLoginForm({super.key});

  @override
  State<EmailLoginForm> createState() => _EmailLoginFormState();
}

class _EmailLoginFormState extends State<EmailLoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController emailInputController = TextEditingController();
    TextEditingController passwordInputController = TextEditingController();

    return Form(
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
                    return null;
                  },
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
                  child: SecondaryButton(
                    text: "Continue",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        String emailAddress = emailInputController.text;
                        String password = passwordInputController.text;

                        context.read<LoginCubit>().setCredentials(
                              email: emailAddress,
                              password: password,
                            );
                      }
                    },
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

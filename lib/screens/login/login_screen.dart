import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:solaris_structure_1/router/routing_constants.dart';
import 'package:solaris_structure_1/widgets/button.dart';
import 'package:solaris_structure_1/widgets/screen.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../widgets/overlay_loading.dart';
import '../../widgets/platform_text_input.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthCubit authCubit = context.read<AuthCubit>();

    return const Screen(
      title: "Login",
      hideBottomNavbar: true,
      child: LoginOptions(),
    );
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

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
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

                        context
                            .read<AuthCubit>()
                            .loginWithPhoneNumber(phoneNumber);
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

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
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

                        context.read<AuthCubit>().loginWithEmail(emailAddress);
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

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:solaris_structure_1/widgets/button.dart';
import 'package:solaris_structure_1/widgets/screen.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../widgets/platform_text_input.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 50),
      child: Column(
        children: [
          Container(
            height: 40,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
                color: Color(0xfff5f5f5),
                borderRadius: const BorderRadius.all(Radius.circular(9.0)),
                border: Border.all(width: 1, color: Color(0xffB9B9B9))),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          PlatformTextInput(
            controller: phoneController,
            textLabel: "Phone number",
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      String phoneNumber = phoneController.text;

                      log("Phone number: $phoneNumber");

                      context.read<AuthCubit>().login(phoneNumber);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
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
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        iosContentPadding: true,
        iosContentBottomPadding: true,
        appBar: PlatformAppBar(
          title: const Text('Login'),
        ),
        body: const LoginOptions());
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
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: PlatformElevatedButton(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Phone Number",
                      softWrap: false,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                    onPressed: () => setState(() => _selectedIndex = 0),
                  ),
                ),
                Expanded(
                  child: PlatformElevatedButton(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Email",
                      softWrap: false,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                    onPressed: () => setState(() => _selectedIndex = 1),
                  ),
                ),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Label"),
              PlatformTextFormField(
                controller: phoneController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
                cupertino: (context, platform) => CupertinoTextFormFieldData(
                    placeholder: 'Phone number',
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 66, 66, 66),
                      ),
                    )),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Forgot your phone number?"),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(
                      const Size.fromHeight(40)),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    String phoneNumber = phoneController.text;

                    log("Phone number: $phoneNumber");

                    context.read<AuthCubit>().login(phoneNumber);
                  }
                },
                child: const Text('Login'),
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

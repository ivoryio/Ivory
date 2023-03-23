import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:solaris_structure_1/screens/signup/confirm_token.dart';

import '../../router/routing_constants.dart';
import '../../cubits/signup/signup_cubit.dart';
import '../../widgets/button.dart';
import '../../widgets/platform_text_input.dart';
import '../../widgets/screen.dart';
import 'setup_passcode.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: BlocBuilder<SignupCubit, SignupState>(builder: (context, state) {
        if (state is SignupLoading) {
          return const LoadingScreen(title: "Sign Up");
        }

        if (state is SignupInitial) {
          return const BasicInfoScreen();
        }

        if (state is BasicInfoComplete) {
          return const SignupSetupPasscodeScreen();
        }

        if (state is SetupPasscode) {
          return const SignupConfirmTokenScreen();
        }

        if (state is ConfirmedUser) {
          return Screen(
            title: "Sign Up",
            child: PrimaryButton(
              text: "Go to landing page",
              onPressed: () => context.go(landingRoute.path),
            ),
          );
        }

        return ErrorScreen();
      }),
    );
  }
}

class BasicInfoScreen extends StatelessWidget {
  const BasicInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
        hideBottomNavbar: true,
        title: "Sign Up",
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 50),
          child: Column(
            children: [
              const Expanded(
                child: SignupForm(),
              )
            ],
          ),
        ));
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  String _inputEmail = "";
  String _inputLastName = "";
  String _inputFirstName = "";
  bool _agreementAccepted = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
              children: [
                PlatformTextInput(
                  textLabel: "First name",
                  hintText: "e.g John",
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      _inputFirstName = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                PlatformTextInput(
                  textLabel: "Last name",
                  hintText: "e.g Doe",
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {
                      _inputLastName = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                PlatformTextInput(
                  textLabel: "Email Address",
                  hintText: "e.g john.doe@email.com",
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    setState(() {
                      _inputEmail = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email address';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Checkbox(
                            value: _agreementAccepted,
                            onChanged: (checked) {
                              setState(() {
                                _agreementAccepted = checked!;
                              });
                            }),
                      ),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                            "I agree with Solaris Terms and Conditions and Privacy Policy",
                            style: TextStyle(
                              fontSize: 16,
                            )),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      PlatformTextButton(
                        child: const Text(
                          "Login",
                        ),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: SecondaryButton(
                    text: "Continue",
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          !_agreementAccepted) {
                        showPlatformDialog(
                          context: context,
                          builder: (_) => PlatformAlertDialog(
                            title: const Text('Signup'),
                            content: const Text(
                                'You need to accept the terms in order to continue'),
                            actions: [
                              PlatformDialogAction(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      }
                      if (_formKey.currentState!.validate() &&
                          _agreementAccepted) {
                        _formKey.currentState!.save();

                        context.read<SignupCubit>().setBasicInfo(
                              email: _inputEmail,
                              firstName: _inputFirstName,
                              lastName: _inputLastName,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:solarisdemo/screens/login/login_consent_screen.dart';

import '../../widgets/checkbox.dart';
import '../../widgets/auth_error.dart';
import '../../widgets/spaced_column.dart';
import '../../widgets/sticky_bottom_content.dart';
import '../../widgets/button.dart';
import '../../widgets/screen.dart';
import '../../utilities/validator.dart';
import '../../cubits/signup/signup_cubit.dart';
import '../../widgets/platform_text_input.dart';
import 'confirm_email_screen.dart';
import 'countdown_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: SignupCubit(),
      child: BlocBuilder<SignupCubit, SignupState>(
        builder: (context, state) {
          if (state is SignupLoading) {
            return const LoadingScreen(title: "Sign Up");
          }

          if (state is SignupInitial) {
            return const BasicInfoScreen();
          }

          if (state is SignupBasicInfoComplete) {
            return GdprConsentScreen(
              bottomStickyWidget: BottomStickyWidget(
                child: StickyBottomContent(
                  buttonText: "I agree",
                  onContinueCallback: () {
                    context.read<SignupCubit>().setGdprConsent(
                          personId: state.personId!,
                          phoneNumber: state.phoneNumber!,
                          passcode: state.passcode!,
                          email: state.email!,
                          firstName: state.firstName!,
                          lastName: state.lastName!,
                        );
                  },
                ),
              ),
            );
          }

          if (state is SignupEmailConfirmed) {
            return const CountdownScreen();
          }

          if (state is SignupGdprConsentComplete) {
            return const SignupConfirmEmailScreen();
          }

          if (state is SignupError) {
            return AuthErrorScreen(message: state.message, title: "Signup");
          }
          return const ErrorScreen();
        },
      ),
    );
  }
}

class BasicInfoScreen extends StatelessWidget {
  const BasicInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Screen(
        hideBottomNavbar: true,
        title: "Sign Up",
        child: Padding(
          padding: EdgeInsets.fromLTRB(30, 10, 30, 50),
          child: Column(
            children: [
              Expanded(
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
  String _inputPhoneNumber = "";
  String _inputPassword = "";
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
            SpacedColumn(
              space: 16,
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
                    if (!Validator.isValidEmailAddress(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                PlatformTextInput(
                  textLabel: "Phone Number",
                  hintText: "e.g 0049 123 456 789",
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    setState(() {
                      _inputPhoneNumber = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    //Todo: Add phone number validation

                    // if (!Validator.isValidPhoneNumber(value)) {
                    //   return 'Please enter a valid phone number';
                    // }
                    return null;
                  },
                ),
                PlatformTextInput(
                  textLabel: "Passcode",
                  hintText: "e.g 123456",
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    setState(() {
                      _inputPassword = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your passcode';
                    }
                    if (!Validator.isValidPasscode(value)) {
                      return 'Please enter a valid passcode, with at least 6 digits';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxWidget(
                      isChecked: _agreementAccepted,
                      onChanged: (bool checked) {
                        setState(() {
                          _agreementAccepted = checked;
                        });
                      },
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
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
                              phoneNumber: _inputPhoneNumber,
                              email: _inputEmail,
                              firstName: _inputFirstName,
                              lastName: _inputLastName,
                              passcode: _inputPassword,
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

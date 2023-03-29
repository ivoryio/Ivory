import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../widgets/screen.dart';
import '../../cubits/login_cubit/login_cubit.dart';

class LoginPasscodeScreen extends StatelessWidget {
  const LoginPasscodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen(
      title: "Login",
      hideBottomNavbar: true,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              LoginPasscodeBody(),
              LoginPasscodeFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPasscodeBody extends StatefulWidget {
  const LoginPasscodeBody({super.key});

  @override
  State<LoginPasscodeBody> createState() => _LoginPasscodeBodyState();
}

class _LoginPasscodeBodyState extends State<LoginPasscodeBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController inputBox1 = TextEditingController();
    FocusNode inputBox1Focus = FocusNode();
    TextEditingController inputBox2 = TextEditingController();
    FocusNode inputBox2Focus = FocusNode();
    TextEditingController inputBox3 = TextEditingController();
    FocusNode inputBox3Focus = FocusNode();
    TextEditingController inputBox4 = TextEditingController();
    FocusNode inputBox4Focus = FocusNode();
    TextEditingController inputBox5 = TextEditingController();
    FocusNode inputBox5Focus = FocusNode();
    TextEditingController inputBox6 = TextEditingController();
    FocusNode inputBox6Focus = FocusNode();

    void onChange() {
      String passcode = inputBox1.text +
          inputBox2.text +
          inputBox3.text +
          inputBox4.text +
          inputBox5.text +
          inputBox6.text;

      if (inputBox1.text.isNotEmpty) {
        FocusScope.of(context)
            .unfocus(disposition: UnfocusDisposition.previouslyFocusedChild);
        FocusScope.of(context).requestFocus(inputBox2Focus);
      }
      if (inputBox2.text.isNotEmpty) {
        FocusScope.of(context)
            .unfocus(disposition: UnfocusDisposition.previouslyFocusedChild);
        FocusScope.of(context).requestFocus(inputBox3Focus);
      }
      if (inputBox3.text.isNotEmpty) {
        FocusScope.of(context)
            .unfocus(disposition: UnfocusDisposition.previouslyFocusedChild);
        FocusScope.of(context).requestFocus(inputBox4Focus);
      }
      if (inputBox4.text.isNotEmpty) {
        FocusScope.of(context)
            .unfocus(disposition: UnfocusDisposition.previouslyFocusedChild);
        FocusScope.of(context).requestFocus(inputBox5Focus);
      }
      if (inputBox5.text.isNotEmpty) {
        FocusScope.of(context)
            .unfocus(disposition: UnfocusDisposition.previouslyFocusedChild);
        FocusScope.of(context).requestFocus(inputBox6Focus);
      }

      if (passcode.length == 6) {
        // OverlayLoadingProgress.start(context, barrierDismissible: false);
        final LoginCubit loginCubit = context.read<LoginCubit>();

        loginCubit.login(passcode);
        // context.read<AuthCubit>().login(passcode);
      }
    }

    inputBox1.addListener(() => onChange());
    inputBox2.addListener(() => onChange());
    inputBox3.addListener(() => onChange());
    inputBox4.addListener(() => onChange());
    inputBox5.addListener(() => onChange());
    inputBox6.addListener(() => onChange());

    return Column(
      children: [
        const Text(
          "Nice to see you again!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 40),
        Center(
          child: Form(
            key: _formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InputCodeBox(
                    controller: inputBox1,
                    focusNode: inputBox1Focus,
                    obscureText: true),
                InputCodeBox(
                    controller: inputBox2,
                    focusNode: inputBox2Focus,
                    obscureText: true),
                InputCodeBox(
                    controller: inputBox3,
                    focusNode: inputBox3Focus,
                    obscureText: true),
                InputCodeBox(
                    controller: inputBox4,
                    focusNode: inputBox4Focus,
                    obscureText: true),
                InputCodeBox(
                    controller: inputBox5,
                    focusNode: inputBox5Focus,
                    obscureText: true),
                InputCodeBox(
                    controller: inputBox6,
                    focusNode: inputBox6Focus,
                    obscureText: true),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class InputCodeBox extends StatelessWidget {
  final bool? obscureText;
  final FocusNode? focusNode;
  final TextEditingController? controller;

  const InputCodeBox({
    super.key,
    this.controller,
    this.focusNode,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 1,
          color: const Color(0xffC4C4C4),
        ),
      ),
      child: PlatformTextFormField(
        focusNode: focusNode,
        controller: controller,
        textAlign: TextAlign.center,
        obscureText: obscureText,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
      ),
    );
  }
}

class LoginPasscodeFooter extends StatelessWidget {
  const LoginPasscodeFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformTextButton(
        child: const Text("Forgot your passcode?"),
        onPressed: () {
          log("Forgot your passcode?");
        });
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits/auth_cubit/auth_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: "Phone number",
              ),
              Tab(
                text: "Email",
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            PhoneNumberLoginForm(),
            Center(
              child: Text("Email login form"),
            ),
          ],
        ),
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 50),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextFormField(
              controller: phoneController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: "Phone number",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              validator: (String? value) {
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
                  child: Text("Forgot your phone number?"),
                ),
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
      ),
    );
  }
}

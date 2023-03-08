import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../cubits/login_cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          backgroundColor: const Color(0xFF000A1F),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15.0),
                        ),
                      ),
                      labelText: 'Username',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                        ),
                        labelText: 'Password',
                        hintText: 'Enter secure password'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<LoginCubit>().login();
                  },
                  child: const Text('Login'),
                )
              ],
            ),
          ),
        ));
  }
}

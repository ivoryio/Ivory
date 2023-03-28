import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:solarisdemo/cubits/auth_cubit/auth_cubit.dart';
import 'package:solarisdemo/services/auth_service.dart';

import '../../models/user.dart';
import '../../widgets/overlay_loading.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  AuthCubit authCubit;
  AuthService authService;

  LoginCubit({
    required this.authCubit,
    required this.authService,
  }) : super(LoginInitial());

  void setEmail(String email) {
    emit(LoginEmail(email: email));
  }

  void setPhoneNumber(String phoneNumber) {
    emit(LoginPhoneNumber(phoneNumber: phoneNumber));
  }

  void login(String passcode) async {
    String username = state.email ?? state.phoneNumber!;

    emit(LoginLoading(email: state.email, phoneNumber: state.phoneNumber));
    try {
      User? user = await authService.login(username, passcode);

      if (user != null) {
        authCubit.emit(AuthState.authenticated(user));
      }
    } catch (e) {
      emit(LoginError(message: e.toString()));
    }
  }
}

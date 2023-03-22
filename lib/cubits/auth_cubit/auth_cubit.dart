import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:solaris_structure_1/widgets/overlay_loading.dart';

import '../../models/oauth_model.dart';
import 'package:solaris_structure_1/services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  late final OauthModel oauthAccessToken;

  AuthCubit({required this.authService})
      : super(const AuthState.unauthenticated());

  void login(String passcode) async {
    String username = state.loginInputEmail ?? state.loginInputPhoneNumber!;

    try {
      User? user = await authService.login(username, passcode);
      if (user != null) {
        emit(AuthState.authenticated(user));
      } else {
        // emit(AuthState.setAuthenticationError(username, 'Invalid passcode'));
      }
    } catch (e) {
      emit(AuthState.setAuthenticationError(username, e.toString()));
    }
    OverlayLoadingProgress.stop();
  }

  void logout() {
    emit(const AuthState.unauthenticated());
  }

  void loginWithEmail(String email) async {
    emit(AuthState.setEmail(email));
  }

  void loginWithPhoneNumber(String phoneNumber) async {
    emit(AuthState.setPhoneNumber(phoneNumber));
  }

  void reset() {
    print("reset");
    emit(const AuthState.reset());
  }
}

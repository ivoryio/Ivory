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

  void login(String phoneNumber) async {
    OauthModel? oauthAccessToken = await authService.getAccessToken();
    await Future.delayed(const Duration(seconds: 2));

    if (oauthAccessToken is OauthModel) {
      emit(AuthState.authenticated(oauthAccessToken));
    } else {
      emit(const AuthState.setAuthenticationError("test error"));
    }

    OverlayLoadingProgress.stop();
  }

  void logout() {
    emit(const AuthState.unauthenticated());
  }
}

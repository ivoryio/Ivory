import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/oauth_model.dart';
import 'package:solaris_structure_1/services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  late final OauthModel oauthAccessToken;

  AuthCubit({required this.authService})
      : super(const AuthState.unauthenticated());

  void login(String phoneNumber) async {
    emit(const AuthState.loading());
    OauthModel? oauthAccessToken = await authService.getAccessToken();
    if (oauthAccessToken is OauthModel) {
      emit(AuthState.authenticated(oauthAccessToken));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  void logout() {
    emit(const AuthState.unauthenticated());
  }
}

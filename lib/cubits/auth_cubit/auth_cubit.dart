import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../../models/user.dart';
import '../../widgets/overlay_loading.dart';

import '../../models/oauth_model.dart';
import '../../services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit({required this.authService})
      : super(const AuthState.unauthenticated());

  void logout() {
    emit(const AuthState.unauthenticated());
  }

  void reset() {
    emit(const AuthState.reset());
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';
import '../../services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit({required this.authService})
      : super(const AuthState.unauthenticated());

  void login(User user) {
    emit(AuthState.authenticated(user));
  }

  void logout() {
    emit(const AuthState.unauthenticated());
  }

  void reset() {
    emit(const AuthState.reset());
  }
}

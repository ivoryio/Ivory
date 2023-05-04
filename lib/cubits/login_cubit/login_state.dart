part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  final User? user;
  final String? email;
  final String? password;
  final String? phoneNumber;
  final String? tan;

  const LoginState({
    this.tan,
    this.user,
    this.email,
    this.password,
    this.phoneNumber,
  });

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {
  const LoginLoading({
    super.tan,
    super.user,
    super.email,
    super.password,
    super.phoneNumber,
  });
}

class LoginRequestConsent extends LoginState {
  const LoginRequestConsent({
    super.user,
    super.email,
    super.password,
    super.phoneNumber,
  });
}

class LoginUserExists extends LoginState {
  const LoginUserExists({
    super.tan,
    super.user,
    super.email,
    super.password,
    super.phoneNumber,
  });
}

class LoginError extends LoginState {
  final String message;

  const LoginError({
    super.email,
    super.phoneNumber,
    required this.message,
  });
}

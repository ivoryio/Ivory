part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  final String? email;
  final String? phoneNumber;

  const LoginState({this.email, this.phoneNumber});

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {
  const LoginLoading({super.email, super.phoneNumber});
}

class LoginEmail extends LoginState {
  const LoginEmail({super.email});
}

class LoginPhoneNumber extends LoginState {
  const LoginPhoneNumber({super.phoneNumber});
}

class LoginError extends LoginState {
  final String message;

  const LoginError({
    super.email,
    super.phoneNumber,
    required this.message,
  });
}

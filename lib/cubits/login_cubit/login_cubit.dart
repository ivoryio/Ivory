import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/user.dart';
import '../auth_cubit/auth_cubit.dart';
import '../../services/auth_service.dart';

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
        authCubit.login(user);
      }
    } on CognitoUserNewPasswordRequiredException catch (e) {
      // handle New Password challenge
    } on CognitoUserMfaRequiredException catch (e) {
      // handle SMS_MFA challenge
    } on CognitoUserSelectMfaTypeException catch (e) {
      // handle SELECT_MFA_TYPE challenge
    } on CognitoUserMfaSetupException catch (e) {
      // handle MFA_SETUP challenge
    } on CognitoUserTotpRequiredException catch (e) {
      // handle SOFTWARE_TOKEN_MFA challenge
    } on CognitoUserCustomChallengeException catch (e) {
      // handle CUSTOM_CHALLENGE challenge
    } on CognitoUserConfirmationNecessaryException catch (e) {
      // handle User Confirmation Necessary
    } on CognitoClientException catch (e) {
      // handle Wrong Username and Password and Cognito Client
      emit(
        const LoginError(message: LoginErrorMessage.wrongUsernameOrPassword),
      );
    } catch (e) {
      emit(const LoginError(message: LoginErrorMessage.unknownError));
    }
  }
}

class LoginErrorMessage {
  static const wrongUsernameOrPassword = "Wrong username or password";
  static const unknownError = "Unknown error";
}

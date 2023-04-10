import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/models/person_account_summary.dart';
import 'package:solarisdemo/services/person_service.dart';

import '../../models/person_model.dart';
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

  void setCredentials({
    String? email,
    String? phoneNumber,
    required String password,
  }) async {
    emit(LoginLoading(
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    ));
    log('setCredentials: $email, $phoneNumber, $password');

    String username = state.email ?? state.phoneNumber!;
    try {
      User? user = await authService.login(username, password);

      if (user != null) {
        emit(LoginUserExists(
          email: email,
          phoneNumber: phoneNumber,
          password: password,
          user: user,
        ));
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
    } on CognitoClientException catch (_) {
      // handle Wrong Username and Password and Cognito Client
      emit(
        const LoginError(message: LoginErrorMessage.wrongUsernameOrPassword),
      );
    } catch (e) {
      emit(const LoginError(message: LoginErrorMessage.unknownError));
    }
  }

  void login(String tan) async {
    try {
      if (state.user == null) {
        throw Exception("User is null");
      }

      PersonService personService = PersonService(user: state.user!);

      emit(
        LoginLoading(
            tan: tan,
            email: state.email,
            phoneNumber: state.phoneNumber,
            password: state.password,
            user: state.user),
      );

      Person? person = await personService.getPerson();
      // PersonAccount? personAccount = await personService.getAccount();

      // Simulate wrong tan verification (input '1111')
      if (tan == '1111') {
        emit(const LoginError(message: LoginErrorMessage.wrongTan));
        return;
      }

      if (state.user == null || person == null) {
        emit(const LoginError(message: LoginErrorMessage.unknownError));
      }

      authCubit.login(AuthenticatedUser(
        person: person!,
        cognito: state.user!,
        personAccount: PersonAccount.fromJson({}),
      ));
    } catch (e) {
      emit(const LoginError(message: LoginErrorMessage.unknownError));
    }
  }
}

class LoginErrorMessage {
  static const wrongTan = "Wrong TAN";
  static const unknownError = "Unknown error";
  static const wrongUsernameOrPassword = "Wrong username or password";
}

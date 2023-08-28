import 'dart:developer';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/rendering.dart';
import 'package:solarisdemo/models/device_activity.dart';
import 'package:solarisdemo/models/device_consent.dart';
import 'package:solarisdemo/services/device_service.dart';

import '../../infrastructure/device/device_service.dart';
import '../../models/person_account.dart';
import '../../models/person_model.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/person_service.dart';
import '../auth_cubit/auth_cubit.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  AuthCubit authCubit;
  AuthService authService;

  LoginCubit({
    required this.authCubit,
    required this.authService,
  }) : super(LoginInitial());

  Future<void> getSavedCredentials() async {
    final credentials = await DeviceService.getCredentialsFromCache();

    if (credentials?.email != null && credentials?.password != null) {
      debugPrint('$credentials');
      emit(const LoginLoading());

      User? user = await authService.login(
        credentials!.email!,
        credentials.password!,
      );

      if (user != null) {
        emit(LoginUserExists(
          user: user,
          email: credentials.email,
          password: credentials.password,
        ));
      }
    }
  }

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

        await DeviceService.saveCredentialsInCache(email!, password);

        String? consentId = await DeviceService.getDeviceConsentId();
        if (consentId.isEmpty) {
          log('consentId is null');
          CreateDeviceConsentResponse? createdConsent =
              await OldDeviceService(user: user).createDeviceConsent();
          if (createdConsent != null) {
            await DeviceService.saveDeviceConsentId(createdConsent.id);
          }
          await OldDeviceService(user: user)
              .createDeviceActivity(DeviceActivityType.CONSENT_PROVIDED);
        }
        await OldDeviceService(user: user)
            .createDeviceActivity(DeviceActivityType.APP_START);
      }
    } on CognitoUserNewPasswordRequiredException {
      // TODO handle New Password challenge
    } on CognitoUserMfaRequiredException {
      // TODO handle SMS_MFA challenge
    } on CognitoUserSelectMfaTypeException {
      // TODO handle SELECT_MFA_TYPE challenge
    } on CognitoUserMfaSetupException {
      // TODO handle MFA_SETUP challenge
    } on CognitoUserTotpRequiredException {
      // TODO handle SOFTWARE_TOKEN_MFA challenge
    } on CognitoUserCustomChallengeException {
      // TODO handle CUSTOM_CHALLENGE challenge
    } on CognitoUserConfirmationNecessaryException {
      // TODO handle User Confirmation Necessary
    } on CognitoClientException catch (_) {
      // TODO handle Wrong Username and Password and Cognito Client
      emit(
        const LoginError(message: LoginErrorMessage.wrongUsernameOrPassword),
      );
    } catch (e) {
      emit(const LoginError(message: LoginErrorMessage.unknownError));
    }
  }

  void login(
    String tan, {
    required void Function() onSuccess,
  }) async {
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
      PersonAccount? personAccount = await personService.getAccount();

      // TODO Simulate wrong tan verification (input '1111')
      if (tan == '1111') {
        emit(const LoginError(message: LoginErrorMessage.wrongTan));
        return;
      }

      if (state.user == null || person == null || personAccount == null) {
        emit(const LoginError(message: LoginErrorMessage.unknownError));
      }

      authCubit.login(AuthenticatedUser(
        person: person!,
        cognito: state.user!,
        personAccount: personAccount!,
      ));
      onSuccess();
    } catch (e) {
      emit(const LoginError(message: LoginErrorMessage.unknownError));
    }
  }

  void requestConsent({
    String? email,
    String? phoneNumber,
    required String password,
  }) {
    emit(LoginRequestConsent(
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      user: state.user,
    ));
  }
}

class LoginErrorMessage {
  static const wrongTan = "Wrong TAN";
  static const unknownError = "Unknown error";
  static const wrongUsernameOrPassword = "Wrong username or password";
}

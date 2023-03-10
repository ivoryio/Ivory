import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:solaris_structure_1/models/oauth_model.dart';
import 'package:solaris_structure_1/services/service_constants.dart';

import '../cubits/auth_cubit/auth_cubit.dart';

class AuthService {
  BuildContext context;
  AuthService({required this.context});

  Future<void> login(String phoneNumber) async {
    try {
      OauthModel? oauthModel = await getAccessToken();
    } catch (e) {
      log(e.toString());
    }
    // get accessToken from API
    // save accessToken to LoginCubit.accessToken
    // login to app (change page to /home)

    // context.read<AuthCubit>().login();
  }

  Future<OauthModel?> getAccessToken() async {
    try {
      Object body = {
        "grant_type": "client_credentials",
        "client_id": "1234567890",
        "client_secret": "1234567890"
      };

      final response = await http.post(Uri.parse(oauthEndpointUrl), body: body);

      if (response.statusCode == 201) {
        var data = jsonDecode(response.body) as Map<String, dynamic>;
        var oauthModel = OauthModel.fromJson(data);

        return oauthModel;
      }
      throw Exception('Failed to get access token');
    } catch (e) {
      log("[AuthService::getAccessToken] $e");
      return null;
    }
  }
}

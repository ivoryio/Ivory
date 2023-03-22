import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'service_constants.dart';
import '../models/oauth_model.dart';

class AuthService {
  BuildContext context;
  AuthService({required this.context});

  Future<OauthModel?> getAccessToken() async {
    try {
      Object body = {
        "grant_type": "client_credentials",
        "client_id": "1234567890",
        "client_secret": "1234567890"
      };
      throw Exception("test");
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

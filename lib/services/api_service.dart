import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../cubits/login_cubit/login_cubit.dart';

class ApiService {
  BuildContext context;
  ApiService({required this.context});

  static const String baseUrl = 'http://localhost:8080';

  Future<http.Response> get(String path) async {
    final url = Uri.parse('$baseUrl/$path');
    return await http.get(url);
  }

  Future<http.Response> post(String path, dynamic body) async {
    final url = Uri.parse('$baseUrl/$path');

    return await http.post(url, body: body);
  }
}

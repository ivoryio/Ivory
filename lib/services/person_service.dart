import 'dart:convert';
import 'package:http/http.dart' as http;

import 'service_constants.dart';

import '../models/oauth_model.dart';
import '../models/person_model.dart';
import '../models/person_account.dart';

class PersonService {
  late final OauthModel oauth;

  PersonService({required this.oauth});

  Future<Person>? getPerson() async {
    try {
      const String personId = 'mockpersonkontistgmbh';

      String url = '$apiBaseUrl/v1/persons/$personId';

      final response = await http.get(Uri.parse(url),
          headers: {"Authorization": "Bearer ${oauth.accessToken}"});

      if (response.statusCode == 200) {
        return Person.fromJson(jsonDecode(response.body));
      }
      throw Exception('Failed to load people');
    } catch (e) {
      throw Exception("Failed to load people");
    }
  }

  Future<List<PersonAccount>?> getPersonAccounts(
      {required String personId}) async {
    try {
      String url = '$apiBaseUrl/v1/persons/$personId/accounts';

      final response = await http.get(Uri.parse(url),
          headers: {"Authorization": "Bearer ${oauth.accessToken}"});

      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List)
            .map((e) => PersonAccount.fromJson(e))
            .toList();
      }
      throw Exception('Failed to load people');
    } catch (e) {
      throw Exception("Failed to load people");
    }
  }
}

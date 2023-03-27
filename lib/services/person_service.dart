import 'dart:developer';

import 'package:solarisdemo/models/person_account_summary.dart';

import 'api_service.dart';

class PersonService extends ApiService {
  PersonService({required super.user});

  Future<PersonAccountSummary>? getPersonAccountSummary() async {
    try {
      String path = 'account/summary';

      var data = await get(path);
      return PersonAccountSummary.fromJson(data);
    } catch (e) {
      throw Exception("Failed to load account summary");
    }
  }
}

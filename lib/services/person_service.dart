import 'package:solarisdemo/models/person_account.dart';

import 'api_service.dart';
import '../models/person_model.dart';
import '../models/person_account_summary.dart';

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

  Future<Person>? getPerson() async {
    try {
      String path = 'person';

      var data = await get(path);
      return Person.fromJson(data);
    } catch (e) {
      throw Exception("Failed to load person");
    }
  }

  Future<PersonAccount>? getAccount() async {
    try {
      String path = 'account';

      var data = await get(path);

      return PersonAccount.fromJson(data);
    } catch (e) {
      throw Exception("Failed to load account");
    }
  }

  Future<dynamic>? createPerson(CreatePerson person) async {
    try {
      String path = 'person';

      var data = await post(path, body: person.toJson());

      return data;
    } catch (e) {
      throw Exception("Failed to create person");
    }
  }
}

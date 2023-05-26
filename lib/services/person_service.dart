import 'dart:developer';

import 'package:solarisdemo/models/person_account.dart';

import '../models/device.dart';
import 'api_service.dart';
import '../models/person_model.dart';
import '../models/person_account_summary.dart';

class PersonService extends ApiService {
  PersonService({
    super.user,
  });

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

  Future<CreatePersonResponse>? createPerson(
      CreatePersonReqBody createPersonReqBody) async {
    try {
      String path = 'person';

      var data = await post(
        path,
        body: createPersonReqBody.toJson(),
        authNeeded: false,
      );

      log("in createSolarisUser");
      return CreatePersonResponse.fromJson(data);
    } catch (e) {
      log('in createSolarisUser catch');
      inspect(e);
      throw Exception("Failed to create person");
    }
  }

  Future<dynamic>? createMobileNumber(
      CreateDeviceReqBody createDeviceReqBody) async {
    try {
      String path = 'person/device';

      var data = await post(
        path,
        body: createDeviceReqBody.toJson(),
      );

      log('in createSolarisMobileDevice');
      inspect(data);

      return data;
    } catch (e) {
      log('in createSolarisMobileDevice catch');
      inspect(e);
      throw Exception("Failed to create mobile number");
    }
  }
}

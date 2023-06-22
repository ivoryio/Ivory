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

      return CreatePersonResponse.fromJson(data);
    } catch (e) {
      throw Exception("Failed to create person");
    }
  }

  Future<dynamic>? createMobileNumber(
      CreateDeviceReqBody createDeviceReqBody) async {
    try {
      String path = 'person/device';

      await post(
        path,
        body: createDeviceReqBody.toJson(),
      );
    } catch (e) {
      throw Exception("Failed to create mobile number");
    }
  }

  Future<CreateTaxIdentificationResponse>? createTaxIdentification(
      CreateTaxIdentificationReqBody createTaxIdentificationReqBody) async {
    try {
      String path = 'person/tax_identification';

      var data = await post(
        path,
        body: createTaxIdentificationReqBody.toJson(),
      );

      return CreateTaxIdentificationResponse.fromJson(data);
    } catch (e) {
      throw Exception("Failed to create tax identification");
    }
  }

  Future<CreateKycResponse>? createKyc(
      CreateKycReqBody createKycReqBody) async {
    try {
      String path = 'person/kyc';

      var data = await post(
        path,
        body: createKycReqBody.toJson(),
      );

      return CreateKycResponse.fromJson(data);
    } catch (e) {
      throw Exception("Failed to create kyc");
    }
  }
}

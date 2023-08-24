import 'package:solarisdemo/infrastructure/person/person_service.dart';
import 'package:solarisdemo/models/person/person_reference_account.dart';
import 'package:solarisdemo/models/user.dart';

class FakePersonService extends PersonService {
  @override
  Future<PersonServiceResponse> getReferenceAccount({User? user}) async {
    return GetReferenceAccountSuccessResponse(
      referenceAccount: const PersonReferenceAccount(name: "test", iban: "iban"),
    );
  }
}

class FakeFailingPersonService extends PersonService {
  @override
  Future<PersonServiceResponse> getReferenceAccount({User? user}) async {
    return PersonServiceErrorResponse();
  }
}

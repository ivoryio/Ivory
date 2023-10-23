import 'package:solarisdemo/infrastructure/person/person_service.dart';
import 'package:solarisdemo/models/person/person_reference_account.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/models/person_model.dart';
import 'package:solarisdemo/models/user.dart';

class FakePersonService extends PersonService {
  @override
  Future<PersonServiceResponse> getPerson({User? user}) async {
    return GetPersonSuccessResponse(
      person: Person(id: 'person-id', firstName: 'firstName', lastName: 'lastName'),
    );
  }

  @override
  Future<PersonServiceResponse> getReferenceAccount({User? user}) async {
    return GetReferenceAccountSuccessResponse(
      referenceAccount: const PersonReferenceAccount(name: "test", iban: "iban"),
    );
  }

  @override
  Future<PersonServiceResponse> getPersonAccount({User? user}) async {
    return GetPersonAccountSuccessResponse(
      personAccount: PersonAccount(),
    );
  }
}

class FakeFailingPersonService extends PersonService {
  @override
  Future<PersonServiceResponse> getPerson({User? user}) async {
    return PersonServiceErrorResponse();
  }

  @override
  Future<PersonServiceResponse> getReferenceAccount({User? user}) async {
    return PersonServiceErrorResponse();
  }

  @override
  Future<PersonServiceResponse> getPersonAccount({User? user}) async {
    return PersonServiceErrorResponse();
  }
}

class FakePersonServiceWithFailingGetPersonAccount extends FakePersonService {
  @override
  Future<PersonServiceResponse> getPersonAccount({User? user}) async {
    return PersonServiceErrorResponse();
  }
}

import 'package:solarisdemo/infrastructure/person/person_service.dart';
import 'package:solarisdemo/models/person/person_reference_account.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/models/person_model.dart';
import 'package:solarisdemo/models/user.dart';

final mockPerson = Person(
  id: 'person-id',
  firstName: 'firstName',
  lastName: 'lastName',
  title: 'title',
  email: 'email',
  city: 'city',
  country: 'country',
  address: const PersonAddress(
    line1: 'line1',
    line2: 'line2',
    postalCode: 'postalCode',
    city: 'city',
    country: 'country',
  ),
  birthCity: 'birthCity',
  birthCountry: 'birthCountry',
  birthDate: DateTime.now(),
  mobileNumber: 'mobileNumber',
  nationality: "nationality",
  occupation: "occupation",
);

class FakePersonService extends PersonService {
  @override
  Future<PersonServiceResponse> getPerson({User? user}) async {
    return GetPersonSuccessResponse(
      person: mockPerson,
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

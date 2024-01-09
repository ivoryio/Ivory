import 'package:equatable/equatable.dart';
import 'package:solarisdemo/config.dart';
import 'package:solarisdemo/models/amount_value.dart';
import 'package:solarisdemo/models/person/person_reference_account.dart';
import 'package:solarisdemo/models/person/person_service_error_type.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/models/person_model.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class PersonService extends ApiService {
  PersonService({super.user});

  Future<PersonServiceResponse> getPerson({User? user}) async {
    if (user != null) {
      this.user = user;
    }

    try {
      final data = ClientConfig.getFeatureFlags().simplifiedLogin
          ? {
              "customerNumber": "ABCDEFGH123456789",
              "dateOfBirth": "1935-01-08T00:00:00.000Z",
              "firstName": "Matti",
              "id": 151077912,
              "lastName": "Korhonen",
              "locale": "af_ZA",
              "middleName": "Juha",
              "nationality": ["string"],
              "regNo": "19560606-1234",
              "role": "CORPORATE",
              "salutation": "Mr"
            }
          : await get('person');

      final person = ClientConfig.getFeatureFlags().simplifiedLogin
          ? Person(
              id: (data['id']).toString(),
              firstName: data['firstName'] as String,
              lastName: '${data['middleName']} ${data['lastName']}',
              salutation: data['salutation'] as String,
            )
          : Person.fromJson(data);

      return GetPersonSuccessResponse(
        person: person,
      );
    } catch (e) {
      return PersonServiceErrorResponse();
    }
  }

  Future<PersonServiceResponse> getReferenceAccount({required User user}) async {
    this.user = user;

    try {
      final data = await get('person/reference_accounts');

      if (data is List && data.isEmpty) {
        return PersonServiceErrorResponse(errorType: PersonServiceErrorType.referenceAccountUnavailable);
      }

      return GetReferenceAccountSuccessResponse(
        referenceAccount: PersonReferenceAccount(
          name: (data as List).first['name'] as String,
          iban: data.first["iban"] as String,
        ),
      );
    } catch (e) {
      return PersonServiceErrorResponse();
    }
  }

  Future<PersonServiceResponse> getPersonAccount({required User user}) async {
    this.user = user;

    try {
      final data = ClientConfig.getFeatureFlags().simplifiedLogin
          ? {
              "available": 1000,
              "balance": 1000,
              "currency": "EUR",
              "customerId": 55667788990,
              "iban": {"iban": "FI7165429021331431"},
              "id": 1234567890,
              "name": "My example account name",
              "number": 123456789,
              "parentId": 9876543210,
              "paymentReference": {"number": 1234567897, "type": "MOD10"},
              "status": "ACCOUNT_OK",
              "template": "string"
            }
          : await get('account');

      final personAccount = ClientConfig.getFeatureFlags().simplifiedLogin
          ? PersonAccount(
              id: (data['id']).toString(),
              iban: data['iban']['iban'] as String,
              type: "unknown",
              income: AmountValue(value: 0, unit: "EUR", currency: "EUR"),
              spending: AmountValue(value: 0, unit: "EUR", currency: "EUR"),
              balance: AmountValue(
                value: double.tryParse((data['balance']).toString()) ?? 0,
                currency: data['currency'] as String,
                unit: "EUR",
              ),
              availableBalance: AmountValue(
                value: double.tryParse((data['available']).toString()) ?? 0,
                currency: data['currency'] as String,
                unit: "EUR",
              ),
              status: data['status'] as String,
            )
          : PersonAccount.fromJson(data);

      return GetPersonAccountSuccessResponse(
        personAccount: personAccount,
      );
    } catch (e) {
      return PersonServiceErrorResponse();
    }
  }
}

abstract class PersonServiceResponse extends Equatable {}

class GetReferenceAccountSuccessResponse extends PersonServiceResponse {
  final PersonReferenceAccount referenceAccount;

  GetReferenceAccountSuccessResponse({required this.referenceAccount});

  @override
  List<Object?> get props => [referenceAccount];
}

class GetPersonAccountSuccessResponse extends PersonServiceResponse {
  final PersonAccount personAccount;

  GetPersonAccountSuccessResponse({required this.personAccount});

  @override
  List<Object?> get props => [personAccount];
}

class GetPersonSuccessResponse extends PersonServiceResponse {
  final Person person;

  GetPersonSuccessResponse({required this.person});

  @override
  List<Object?> get props => [person];
}

class PersonServiceErrorResponse extends PersonServiceResponse {
  final PersonServiceErrorType errorType;

  PersonServiceErrorResponse({this.errorType = PersonServiceErrorType.unknown});

  @override
  List<Object?> get props => [];
}

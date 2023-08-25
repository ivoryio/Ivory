import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/person/person_reference_account.dart';
import 'package:solarisdemo/models/person/person_service_error_type.dart';
import 'package:solarisdemo/models/person_account.dart';
import 'package:solarisdemo/models/user.dart';
import 'package:solarisdemo/services/api_service.dart';

class PersonService extends ApiService {
  PersonService({super.user});

  Future<PersonServiceResponse> getReferenceAccount({User? user}) async {
    if (user != null) {
      this.user = user;
    }

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

  Future<PersonServiceResponse> getPersonAccount({User? user}) async {
    if (user != null) {
      this.user = user;
    }

    try {
      final data = await get('account');

      return GetPersonAccountSuccessResponse(
        personAccount: PersonAccount.fromJson(data),
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

class PersonServiceErrorResponse extends PersonServiceResponse {
  final PersonServiceErrorType errorType;

  PersonServiceErrorResponse({this.errorType = PersonServiceErrorType.unknown});

  @override
  List<Object?> get props => [];
}

import 'package:equatable/equatable.dart';
import 'package:solarisdemo/models/person/person_service_error_type.dart';
import 'package:solarisdemo/models/person/reference_account.dart';
import 'package:solarisdemo/services/api_service.dart';

class PersonService extends ApiService {
  PersonService({super.user});

  Future<PersonServiceResponse> getReferenceAccount() async {
    return GetReferenceAccountSuccessResponse(
      referenceAccount: const ReferenceAccount(name: "test", iban: "iban"),
    );
  }
}

abstract class PersonServiceResponse extends Equatable {}

class GetReferenceAccountSuccessResponse extends PersonServiceResponse {
  final ReferenceAccount referenceAccount;

  GetReferenceAccountSuccessResponse({required this.referenceAccount});

  @override
  List<Object?> get props => [referenceAccount];
}

class PersonServiceErrorResponse extends PersonServiceResponse {
  final PersonServiceErrorType errorType;

  PersonServiceErrorResponse({this.errorType = PersonServiceErrorType.unknown});

  @override
  List<Object?> get props => [];
}

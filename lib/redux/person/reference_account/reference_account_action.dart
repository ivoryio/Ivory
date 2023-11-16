import 'package:solarisdemo/models/person/person_reference_account.dart';
import 'package:solarisdemo/models/person/person_service_error_type.dart';

class GetReferenceAccountCommandAction {}

class ReferenceAccountLoadingEventAction {}

class ReferenceAccountFetchedEventAction {
  final PersonReferenceAccount referenceAccount;

  ReferenceAccountFetchedEventAction(this.referenceAccount);
}

class GetReferenceAccountFailedEventAction {
  PersonServiceErrorType errorType;

  GetReferenceAccountFailedEventAction({this.errorType = PersonServiceErrorType.unknown});
}

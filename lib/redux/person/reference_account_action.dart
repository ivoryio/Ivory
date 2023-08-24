import 'package:solarisdemo/models/person/person_reference_account.dart';

class GetReferenceAccountCommandAction {}

class GetReferenceAccountLoadingEventAction {}

class GetReferenceAccountSuccessEventAction {
  final PersonReferenceAccount referenceAccount;

  GetReferenceAccountSuccessEventAction(this.referenceAccount);
}

class GetReferenceAccountFailedEventAction {}
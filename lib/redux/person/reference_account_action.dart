import 'package:solarisdemo/models/person/reference_account.dart';

class GetReferenceAccountCommandAction {}

class GetReferenceAccountLoadingEventAction {}

class GetReferenceAccountSuccessEventAction {
  final ReferenceAccount referenceAccount;

  GetReferenceAccountSuccessEventAction(this.referenceAccount);
}

class GetReferenceAccountFailureEventAction {
  final String error;

  GetReferenceAccountFailureEventAction(this.error);
}

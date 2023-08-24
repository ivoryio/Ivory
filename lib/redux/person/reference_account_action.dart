import 'package:solarisdemo/models/person/person_reference_account.dart';
import 'package:solarisdemo/models/user.dart';

class GetReferenceAccountCommandAction {
  final User user;

  GetReferenceAccountCommandAction({required this.user});
}

class GetReferenceAccountLoadingEventAction {}

class GetReferenceAccountSuccessEventAction {
  final PersonReferenceAccount referenceAccount;

  GetReferenceAccountSuccessEventAction(this.referenceAccount);
}

class GetReferenceAccountFailedEventAction {}
